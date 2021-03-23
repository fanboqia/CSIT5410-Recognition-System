% MYFLD classifies an input sample into either class 1 or class 2.
%
%   [output_class w] = myfld(input_sample, class1_samples, class2_samples) 
%   classifies an input sample into either class 1 or class 2,
%   from samples of class 1 (class1_samples) and samples of
%   class 2 (class2_samples).
% 
% The implementation of the Fisher linear discriminant must follow the
% descriptions given in the lecture notes.
% In this assignment, you do not need to handle cases when 'inv' function
% input is a matrix which is badly scaled, singular or nearly singular.
% All calculations are done using double-precision floating point. 
%
% Input parameters:
% input_sample = an input sample
%   - The number of dimensions of the input sample is N.
%
% class1_samples = a NC1xN matrix
%   - class1_samples contains all samples taken from class 1.
%   - The number of samples is NC1.
%   - The number of dimensions of each sample is N.
%
% class2_samples = a NC2xN matrix
%   - class2_samples contains all samples taken from class 2.
%   - The number of samples is NC2.
%   - NC1 and NC2 do not need to be the same.
%   - The number of dimensions of each sample is N.
%
% Output parameters:
% output_class = the class to which input_sample belongs. 
%   - output_class should have the value either 1 or 2.
%
% w = weight vector.
%   - The vector length must be one.
%
% For ALL submitted files in this assignment, 
%   you CANNOT use the following MATLAB functions:
%   ClassificationDiscriminant, CLASSIFY, eval, mahal.
function [output_class, w] = myfld(input_sample, class1_samples, class2_samples)

