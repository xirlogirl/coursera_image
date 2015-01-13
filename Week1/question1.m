% Write a computer program capable of reducing the number of intensity levels in an image from 256 to 2, 
% in integer powers of 2. The desired number of intensity levels needs to be a variable input to your program.
%% Question 1
function reduce_n()

% Simple RGB image
f = imread('/Users/akanwar/Documents/Image Processing course/assignments/saturn.jpg');

% Just work with 1 band, grayscale uint8, range is 0 to 255
% convert to double - the range of the image is now 0 to 1 - 64 bit float
% per pixel
im = im2double(rgb2gray(f));


% Let nlevel be the number of desired graylevels
nlevel = input('Num levels?');

% Since the image array is a double, division will be an integer
im2 = floor(im/(1/nlevel));

figure;
imshow(im2, [])
