
class1_samples=[1 2;2 3;3 4;4 5;5 6]; % each row represents a pair of x and y coordinates
class2_samples=[1 0;2 0;3 2;3 3;1 3;2 5]; % each row represents a pair of x and y coordinates
input_sample=[2 5]; % [x y] coordinates
[output_class, w] = myfld(input_sample, class1_samples, class2_samples)