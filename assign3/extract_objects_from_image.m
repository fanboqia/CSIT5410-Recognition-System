function [fe1_set,fe2_set,fe3_set,fe4_set,fe5_set,labels] = extract_objects_from_image(VOCopts,training_set)
  fe1_set = [];
  fe2_set = [];
  fe3_set = [];
  fe4_set = [];
  fe5_set = [];
  labels = [];
  wbr = waitbar(0,'Please wait...');
  for i=1:length(training_set)
    %disp(["epoch:",num2str(i)]);
    waitbar(i / length(training_set));
    % read annotation
    rec=PASreadrecord(sprintf(VOCopts.annopath,training_set{i}));
    for j=1:length(rec.objects)
      % extract the dog object
      if strcmpi(rec.objects(j).class,'dog') == 1
        %label as 1
        labels = [labels;1];
        
        I = imread(sprintf(VOCopts.imgpath,training_set{i}));
        [fe1_set,fe2_set,fe3_set,fe4_set,fe5_set] = preprocess(I,rec.objects(j).bbox,fe1_set,fe2_set,fe3_set,fe4_set,fe5_set);
        
      % try to balance the number of positive and negative samples for better SVM performance
      elseif length(labels)/2 < sum(labels)
        labels = [labels;0];
        
        I = imread(sprintf(VOCopts.imgpath,training_set{i}));
        [fe1_set,fe2_set,fe3_set,fe4_set,fe5_set] = preprocess(I,rec.objects(j).bbox,fe1_set,fe2_set,fe3_set,fe4_set,fe5_set);
        
      end
    end 
  end
  close(wbr);
end

function [fe1_set,fe2_set,fe3_set,fe4_set,fe5_set] = preprocess(I,bb,fe1_set,fe2_set,fe3_set,fe4_set,fe5_set)
  % test whether the image is RGB or grayscale
  if length(size(I)) == 3
    I = rgb2gray(I);
  end
  I = histeq(I);
  
  x_range = [bb(1):bb(3)];
  y_range = [bb(2):bb(4)];
  I_target = I(y_range,x_range,:);
  fe1 = feature_extract(imresize(I_target,[128,128]));
  fe2 = feature_extract(imresize(I_target,[64,64]));
  fe3 = feature_extract(imresize(I_target,[48,48]));
  fe4 = feature_extract(imresize(I_target,[32,32]));
  fe5 = feature_extract(imresize(I_target,[16,16]));
  fe1_set = [fe1_set;fe1];
  fe2_set = [fe2_set;fe2];
  fe3_set = [fe3_set;fe3];
  fe4_set = [fe4_set;fe4];
  fe5_set = [fe5_set;fe5];
end