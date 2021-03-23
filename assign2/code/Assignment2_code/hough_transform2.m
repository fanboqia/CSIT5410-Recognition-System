inputs = [1,2,3];
for i = 3:length(inputs)
    %%%% read the input images %%%%
    img_name = ['hough_',num2str(inputs(i)), '.JPG'];
    img = imread(img_name);
    
    %%%% pre-processing %%%%
    %%%% you can change this part to fit your implementation %%%%
    preproc_img = rgb2gray(img);
    [M ,N] = size(preproc_img);
    %preproc_img = imgaussfilt(preproc_img,12);
    %preproc_img(preproc_img<140)=0; 
    %preproc_img(preproc_img>=140)=255;
    %preproc_img = histeq(preproc_img);
    preproc_img = imsmooth(preproc_img,'Gaussian',2.5);
    %preproc_img(preproc_img<140)=0; 
    %preproc_img(preproc_img>=140)=255;
    
    %%%% to-do 1: edge extraction. %%%%   
    
    edge_img = edge(preproc_img,'prewitt',0.04);
    %se1 = strel('line',11,0);
    %se2 = strel('line',11,90);
    %edge_img = imdilate(edge_img,se1);
    %edge_img = imdilate(edge_img,se2);
    figure;
    imshow(edge_img);

    %%%% to-do 2: Hough transform to find 4 sides of the paper %%%% 
    
    rho = sqrt((M^2+N^2));
    max_rho = floor(rho)-1;
    min_rho = -max_rho;
    
    min_theta = -90;
    max_theta = 90;
    
    table = zeros(max_rho*2,max_theta*2);
    
    % load pre-computed hough transform
    txt_name = ['hough_',num2str(inputs(i)),'.txt'];
    wb = waitbar(0, 'Hough Transform');
    for x=1:M
      waitbar(x/M, wb);
      for y=1:N
        if edge_img(x,y) == 1
          for angle = min_theta:max_theta-1
            cal_rho = round((x-1) * cosd(angle) + (y-1) * sind(angle));
            rho_index = uint16(cal_rho+max_rho+1);
            theta_index = uint16(angle+max_theta+1);
            table(rho_index,theta_index) = table(rho_index,theta_index) + 1;
          endfor
        endif
      endfor
    endfor
    %save(txt_name,"table");
    close(wb);
    
    % find the top 4 largest value
    max_arr = [0,0,0,0];
    max_index = zeros(4,2);
    table_copy = table;

    for count=1:20
      max_arr(count) = max(max(table_copy));
      [i,j]=find(table_copy==max(max(table_copy)));
      max_index(count,1) = i(1) - max_rho - 1;
      max_index(count,2) = j(1) - max_theta - 1;
      table_copy(i,j) = 0;
    endfor 

    % get the four intersection points by the four lines
    intersections = [];
    for k=1:length(max_arr)
      rho1 = max_index(k,:)(1);
      theta1 = max_index(k,:)(2);
      for p=k+1:length(max_arr)
        rho2 = max_index(p,:)(1);
        theta2 = max_index(p,:)(2);
        angle_sum = abs(theta1) + abs(theta2);
        if angle_sum > 80 && angle_sum < 100
          res = inv([cosd(theta1),sind(theta1);cosd(theta2),sind(theta2)])*[rho1;rho2];
          intersections = [intersections res];
        endif
      endfor
    endfor

    % find the relationship between the four points
    x1 = intersections(:,1)(2);
    y1 = intersections(:,1)(1);
    dists = [];
    max_ptr_dist = 0;
    max_ptr_index = 0;
    for l=2:length(intersections)
      x2 = intersections(:,l)(2);
      y2 = intersections(:,l)(1);
      dist = sqrt((x1-x2)^2+(y1-y2)^2);
      if dist > max_ptr_dist
        max_ptr_dist = dist;
        max_ptr_index = l;
      endif
    endfor
    if max_ptr_index == 2
      lines = [[2,3];[2,4];[1,3];[1,4]];
    elseif max_ptr_index == 3
      lines = [[3,2];[3,4];[1,2];[1,4]];
    elseif max_ptr_index == 4
      lines = [[1,2];[1,3];[4,2];[4,3]];
    endif
    
    %%%% plot four green lines on the input image %%%%
    figure, imshow(img), hold on
    for l=1:4
      _y = intersections(:,lines(l,:))(1,:);
      _x = intersections(:,lines(l,:))(2,:);
      plot(_x,_y,'LineWidth',2,'Color','green');
    endfor 
end





  