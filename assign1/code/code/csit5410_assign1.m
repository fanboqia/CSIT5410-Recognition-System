% CSIT5410_ASSIGN1.m contains the main routine for CSIT5410 assignment 1.
%

img = imread('assignment1.png');

% Task 1
level1 = 2;
level2 = 16;
level3 = 64;

q1_img = myquantizer(img, level1);
q2_img = myquantizer(img, level2);
q3_img = myquantizer(img, level3);

figure,
subplot(221), imshow(img);
subplot(222), imshow(q1_img);
subplot(223), imshow(q2_img);
subplot(224), imshow(q3_img);

% Task 2
scale1 = [300, 400];
scale2 = [200, 100];
scale3 = [128, 128];

s1_img = myscaler(img, scale1);
s2_img = myscaler(img, scale2);
s3_img = myscaler(img, scale3);

figure,
subplot(221), imshow(img);
subplot(222), imshow(s1_img);
subplot(223), imshow(s2_img);
subplot(224), imshow(s3_img);

% Task 3

% Generate the corresponding binary edge image of the given image img.
img = im2double(img);
T = double(max(max(img)))*0.2;
direction = 'all';
g = mysobeledge(img,T,direction);
% Show the image in a new window.
figure;imshow(g, [0 1]);title('Binary Edge Image 1');
disp('The corresponding binary edge image is computed and displayed successfully.');

% Generate the corresponding binary edge image of the given image img
% without specifying the threshold
direction = 'all';
f = mysobeledge(img,[],direction);
% Show the image in a new window.
figure;imshow(f, [0 1]);title('Binary Edge Image 2');
disp('The corresponding binary edge image is computed and displayed successfully.');