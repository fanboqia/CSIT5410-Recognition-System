intersections = [];
for k=1:4
  rho1 = extract_index(k,:)(1);
  theta1 = extract_index(k,:)(2);
  for p=k+1:4
    rho2 = extract_index(p,:)(1);
    theta2 = extract_index(p,:)(2);
    angle_sum = abs(theta1) + abs(theta2);
    if angle_sum > 80 && angle_sum < 100
      res = inv([cosd(theta1),sind(theta1);cosd(theta2),sind(theta2)])*[rho1;rho2];
      intersections = [intersections res];
    endif
  endfor
endfor

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
figure, imshow(img), hold on
for l=1:4
  _y = intersections(:,lines(l,:))(1,:);
  _x = intersections(:,lines(l,:))(2,:);
  plot(_x,_y,'LineWidth',2,'Color','green');
endfor