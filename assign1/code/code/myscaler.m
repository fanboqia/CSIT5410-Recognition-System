% myscaler takes a gray image and a target size as input, and generates the scaled image as output
%
%   output_img = myscaler(img, output_size) computes the rescaled image output_img
%   from the input image img, output_size indicates the new size
%
% The function prototype is â€œmyscaler(img, output_size) â†? output_imgâ€?, 
% where 'img' and 'output_img' are two-dimensional matrices storing images, 
% and 'output_size' is a tuple of (width, height) defining the spatial resolution of output.

function output_img = myscaler(img, output_size)
  [m,n] = size(img);
  width = output_size(1);
  height = output_size(2);
  output_img = uint8(zeros(height,width));
  
  ratio_x = n/width;
  ratio_y = m/height;
  
  for i=1:height
    for j=1:width
      % get the surrounding four points
      min_x = bound(floor(j*ratio_x),1,n);
      max_x = bound(ceil(j*ratio_x),1,n);
      min_y = bound(floor(i*ratio_y),1,m);
      max_y = bound(ceil(i*ratio_y),1,m);
      
      % get the weight for x and y direction
      weight_x = (ratio_x * j) - min_x;
      weight_y = (ratio_y * i) - min_y;
      
      % get the original image points
      top_left = img(min_y,min_x);
      top_right = img(min_y,max_x);
      bottom_left = img(max_y,min_x);
      bottom_right = img(max_y,max_x);
      
      % bilinear interpolations
      merge = top_left * (1 - weight_x) * (1 - weight_y) + top_right * weight_x * (1 - weight_y) + bottom_left * weight_y * (1 - weight_x) + bottom_right * weight_x * weight_y;
      
      output_img(i,j) = merge;      
    endfor
  endfor
  
function ret = bound(val, low, high)
  ret = min(max(val,low),high);