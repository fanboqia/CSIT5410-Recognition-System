% mysobeledge computes a binary edge image from the given image.
%
%   g = mysobeledge(img,T,direction) computes the binary edge image from the
%   input image img.
%   
% The function mysobeledge, with the format g=mysobeledge(img,T,direction), 
% computes the binary edge image from the input image img. This function takes 
% an intensity image img as its input, and returns a binary image g of the 
% same size as img (mxn), with 1's where the function finds edges in Im and 0's 
% elsewhere. This function finds edges using the Sobel approximation to the 
% derivatives with the assumption that input image values outside the bounds 
% are zero and all calculations are done using double-precision floating 
% point. The function returns g with size mxn. The image g contains edges at 
% those points where the absolute filter response is above or equal to the 
% threshold T.
%   
%       Input parameters:
%       img = An intensity gray scale image.
%       T = Threshold for generating the binary output image. If you do not
%       specify T, or if T is empty ([ ]), mysobeledge(img,[],direction) 
%       chooses the value automatically according to the Algorithm 1 (refer
%       to the assignment descripton).
%       direction = A string for specifying whether to look for
%       'horizontal' edges, 'vertical' edges, positive 45 degree 'pos45'
%       edges, negative 45 degree 'neg45' edges or 'all' edges.
%
%   For ALL submitted files in this assignment, 
%   you CANNOT use the following MATLAB functions:
%   edge, fspecial, imfilter, conv, conv2.
%
function g = mysobeledge(img,T,direction)
  
  %define mask matrix for all directions
  %horizontal
  horizontal = [-1,-2,-1;0,0,0;1,2,1];
  %vertical
  vertical = [-1,0,1;-2,0,2;-1,0,1];
  %pos45
  pos45 = [-2,-1,0;-1,0,1;0,1,2];
  %neg45
  neg45 = [0,1,2;-1,0,1;-2,-1,0];
  
  %padding zeros to the img so that remains the size of the image same after filtering
  [m,n] = size(img);
  pad_img = zeros(m+2,n+2);
  pad_img(2:m+1,2:n+1) = img;
  g = zeros(m,n);
  
  % run the sobel edge detection algorithm
  for i=2:m
    for j=2:n
      if strcmp(direction,'horizontal')
        g(i-1,j-1)=abs(sum(pad_img(i-1:i+1,j-1:j+1)(:).*horizontal(:)));
      endif
      if strcmp(direction,'vertical')
        g(i-1,j-1)=abs(sum(pad_img(i-1:i+1,j-1:j+1)(:).*vertical(:)));
      endif
      if strcmp(direction,'pos45')
        g(i-1,j-1)=abs(sum(pad_img(i-1:i+1,j-1:j+1)(:).*pos45(:)));
      endif
      if strcmp(direction,'neg45')
        g(i-1,j-1)=abs(sum(pad_img(i-1:i+1,j-1:j+1)(:).*neg45(:)));
      endif
      if strcmp(direction,'all')
        hor=abs(sum(pad_img(i-1:i+1,j-1:j+1)(:).*horizontal(:)));
        ver=abs(sum(pad_img(i-1:i+1,j-1:j+1)(:).*vertical(:)));
        pos=abs(sum(pad_img(i-1:i+1,j-1:j+1)(:).*pos45(:)));
        neg=abs(sum(pad_img(i-1:i+1,j-1:j+1)(:).*neg45(:)));
        g(i-1,j-1)=max([hor,ver,pos,neg]);
      endif
    endfor
  endfor
  
  % run algorithm 1
  if isempty(T)
    g_min = min(min(g));
    g_max = max(max(g));
    T = mean([g_min,g_max]);
    prev_T = 0.1*T;
    while abs((T-prev_T))/T >= 0.05
      g1 = g(g>=T);
      g2 = g(g<T);
      m1 = mean(g1(:));
      m2 = mean(g2(:));
      prev_T = T;
      T = mean([m1,m2]);
    end
  endif
  
  %filter g
  g(g<=T) = 0;
  g(g>T) = 1;
