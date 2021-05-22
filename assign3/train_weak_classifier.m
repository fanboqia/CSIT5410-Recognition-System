function train_weak_classifier

% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);

% initialize VOC options
VOCinit;

% load image set
[ids,gt]=textread(sprintf(VOCopts.imgsetpath,"dog_train"),'%s %d');

% Complete Task 2.1 - 2.4 here
training_num = 2501;
training_set = ids(1:training_num,:);

% extract objects from an image
[fe1_set,fe2_set,fe3_set,fe4_set,fe5_set,labels] = extract_objects_from_image(VOCopts,training_set);

% save the feature vector sets
for i=1:5
  txt_name = ['training',num2str(i),'_set','.txt'];
  variable_name = strcat('fe',num2str(i),'_set');
  save(txt_name,variable_name,'-ascii');
end
% save the training labels
save('training_labels.txt','labels','-ascii');

% Save the trained model

SVM_model1 = fitcsvm(fe1_set,labels,'Standardize',true,'KernelFunction','polynomial',...
    'KernelScale','auto');
SVM_model2 = fitcsvm(fe2_set,labels,'Standardize',true,'KernelFunction','polynomial',...
    'KernelScale','auto');
SVM_model3 = fitcsvm(fe3_set,labels,'Standardize',true,'KernelFunction','polynomial',...
    'KernelScale','auto');
SVM_model4 = fitcsvm(fe4_set,labels,'Standardize',true,'KernelFunction','polynomial',...
    'KernelScale','auto');
SVM_model5 = fitcsvm(fe5_set,labels,'Standardize',true,'KernelFunction','polynomial',...
    'KernelScale','auto');

for i=1:5
  filename = ['SVMModel',num2str(i)];
  variable_name = strcat('SVM_model',num2str(i));
  save(filename, variable_name);
end

end
