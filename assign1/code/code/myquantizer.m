% myquantizer takes a gray image and a target number of gray levels as input, 
% and generates the quantized image as output ;
%
%   output_img = myquantizer(img, level) computes the quantized image
%   output_img from the input image img, level indicates the gray level of
%   the quantized image
%   
% The function prototype is â€œmyquantizer(input_img, level) â†? output_imgâ€?, 
% where â€œlevelâ€? is an integer in [0, 255] defining the number of gray levels of output, 
% â€œinput_imgâ€? is an image with 256 gray levels. 
% Note that, computers always represent â€œwhiteâ€? via the pixel value of 255(for uint8). 
% For example, when â€œlevelâ€? == 4, the resulting image should contain pixels of {0, 85, 170, 255}, 
% instead of {0, 1, 2, 3}.

function output_img = myquantizer(img, level)
  [r,c] = size(img);
  output_img = uint8(zeros(r,c));
  range = uint8([]);
  gap = uint8(255 / (level-1));
  for i=0:level-1
    range=[range,i*gap];
  endfor
  for i=1:r
    for j=1:c
      k = 1;
      while (k ~= level) && (img(i,j) >= range(k))  
        k = k + 1;
      end
      left = img(i,j) - range(k-1);
      right = range(k) - img(i,j);
      if left < right
        output_img(i,j) = range(k-1);
      else
        output_img(i,j) = range(k);
      endif
    endfor
  endfor
