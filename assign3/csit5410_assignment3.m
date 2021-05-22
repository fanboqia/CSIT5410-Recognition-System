close all;
clear;

%%%%%%%%%%%%%% Task 2 train weak classifiers
%train_weak_classifier;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);

% initialize VOC options
VOCinit;

% load image set for Adaboost
%[ids,gt]=textread(sprintf(VOCopts.imgsetpath,"dog_val"),'%s %d');

% load test image set for evaluation
%[ids_test,gt_test]=textread(sprintf(VOCopts.imgsetpath,"csit5410_test"),'%s %d');

% Complete Task 3.1 - 3.3 here
% Task 3.1 train SVMs
% step 1: load weak classifiers
wc1 = load('SVMModel1').SVM_model1;
wc2 = load('SVMModel2').SVM_model2;
wc3 = load('SVMModel3').SVM_model3;
wc4 = load('SVMModel4').SVM_model4;
wc5 = load('SVMModel5').SVM_model5;

%{
[test1_set,test2_set,test3_set,test4_set,test5_set,test_labels] = extract_objects_from_image(VOCopts,ids_test);
test1_result = predict(wc1,test1_set);
disp(['Correctness (Weak Classifier 1):', num2str(sum(test1_result == test_labels)),'/',num2str(length(test_labels))]);
test2_result = predict(wc2,test2_set);
disp(['Correctness (Weak Classifier 2):', num2str(sum(test2_result == test_labels)),'/',num2str(length(test_labels))]);
test3_result = predict(wc3,test3_set);
disp(['Correctness (Weak Classifier 3):', num2str(sum(test3_result == test_labels)),'/',num2str(length(test_labels))]);
test4_result = predict(wc4,test4_set);
disp(['Correctness (Weak Classifier 4):', num2str(sum(test4_result == test_labels)),'/',num2str(length(test_labels))]);
test5_result = predict(wc5,test5_set);
disp(['Correctness (Weak Classifier 5):', num2str(sum(test5_result == test_labels)),'/',num2str(length(test_labels))]);

% Task 3.2 Adaboost
[val1_set,val2_set,val3_set,val4_set,val5_set,val_labels] = extract_objects_from_image(VOCopts,ids);
for i=1:5
  txt_name = ['val',num2str(i),'_set','.txt'];
  variable_name = strcat('val',num2str(i),'_set');
  save(txt_name,variable_name,'-ascii');
end
val_labels(val_labels == 0) = -1;
save('val_labels.txt','val_labels','-ascii');
val1_result = predict(wc1,val1_set);
val2_result = predict(wc2,val2_set);
val3_result = predict(wc3,val3_set);
val4_result = predict(wc4,val4_set);
val5_result = predict(wc5,val5_set);
val1_result(val1_result == 0) = -1;
val2_result(val2_result == 0) = -1;
val3_result(val3_result == 0) = -1;
val4_result(val4_result == 0) = -1;
val5_result(val5_result == 0) = -1;
N = length(val_labels);
w = (1/N).* ones(N,1);
alpha = zeros(5,1);
yh = zeros(5,length(val_labels));
yh(1,:) = (val1_result.*val_labels);
yh(2,:) = (val2_result.*val_labels);
yh(3,:) = (val3_result.*val_labels);
yh(4,:) = (val4_result.*val_labels);
yh(5,:) = (val5_result.*val_labels);

for i=1:5
    % normalize all weights
    w = w./sum(w);
    % select the weak classifier with minimum error
    e1 = (0.5*(1-yh(1,:)))*w;
    e2 = (0.5*(1-yh(2,:)))*w;
    e3 = (0.5*(1-yh(3,:)))*w;
    e4 = (0.5*(1-yh(4,:)))*w;
    e5 = (0.5*(1-yh(5,:)))*w;
    [ek,idx] = min([e1,e2,e3,e4,e5]);
    alpha(idx) = 0.5*log((1-ek)/ek);
    % reweight
    w = w.*exp((-1*alpha(idx)*yh(idx,:)))';
end

save('alpha','alpha');
ada_result = (alpha(1)*val1_result + alpha(2)*val2_result + alpha(3)*val3_result + alpha(4)*val4_result + alpha(5)*val5_result);
threshold = 0;
ada_result(ada_result>threshold) = 1;
ada_result(ada_result<=threshold) = -1;
disp(['Correctness (Weak Classifier 1):', num2str(sum(val1_result == val_labels)),'/',num2str(length(val_labels))]);
disp(['Correctness (Weak Classifier 2):', num2str(sum(val2_result == val_labels)),'/',num2str(length(val_labels))]);
disp(['Correctness (Weak Classifier 3):', num2str(sum(val3_result == val_labels)),'/',num2str(length(val_labels))]);
disp(['Correctness (Weak Classifier 4):', num2str(sum(val4_result == val_labels)),'/',num2str(length(val_labels))]);
disp(['Correctness (Weak Classifier 5):', num2str(sum(val5_result == val_labels)),'/',num2str(length(val_labels))]);
disp(['Correctness (Strong Classifier):', num2str(sum(ada_result==val_labels)),'/',num2str(length(val_labels))]);
%}

% Task 3.3 Sliding window
alpha = load('alpha').alpha;
sliding_window(wc1,wc2,wc3,wc4,wc5,alpha);


