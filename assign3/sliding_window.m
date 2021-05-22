function sliding_window(wc1,wc2,wc3,wc4,wc5,alpha)
    alpha = alpha/sum(alpha);
    % open the test_images
    Files=dir('test_images');
    for k=3:length(Files)
        file_name = Files(k).name;
        img_path = ['test_images/',file_name];
        test_img = imread(img_path);
        test_img_processed = test_img;
        % preprocess test images
        if length(size(test_img)) == 3
            test_img_processed = rgb2gray(test_img);
        end
        test_img_processed = histeq(test_img_processed);
        test_img_processed = double(test_img_processed)/255;
        % store the box 
        boxes = [];
        [m,n] = size(test_img_processed);
        % run the sliding window
        for i=1:150:m-128
            for j=1:150:n-128
                %get the sub image
                sub_image = test_img_processed(i:i+127,j:j+127);
                fe1 = feature_extract(imresize(sub_image,[128,128]));
                fe2 = feature_extract(imresize(sub_image,[64,64]));
                fe3 = feature_extract(imresize(sub_image,[48,48]));
                fe4 = feature_extract(imresize(sub_image,[32,32]));
                fe5 = feature_extract(imresize(sub_image,[16,16]));
                %make predict
                val1_result = predict(wc1,fe1);
                val2_result = predict(wc2,fe2);
                val3_result = predict(wc3,fe3);
                val4_result = predict(wc4,fe4);
                val5_result = predict(wc5,fe5);
                
                ada_result = (alpha(1)*val1_result + alpha(2)*val2_result + alpha(3)*val3_result + alpha(4)*val4_result + alpha(5)*val5_result);
                if ada_result > 0.5
                    boxes = [boxes; [ada_result i j i+127 j+127]];
                end 
            end
        end
        
        % find the top three boxes
        top_boxes = maxk(boxes,3,1);
        figure;
        imshow(img_path);
        hold on;
        %draw boxes on the image
        for i=1:size(top_boxes,1)
            text(top_boxes(i,2),top_boxes(i,3)+ 12, num2str(top_boxes(i,1)),'Color','yellow');
            rectangle('Position', top_boxes(i,2:5),'LineWidth',2,'LineStyle','-','EdgeColor','y'); 
        end
     end
end