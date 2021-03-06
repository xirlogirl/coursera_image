%% using nlfilter-- grayscale only
function imAvger()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in image
f = imread('/Users/akanwar/Documents/Image Processing course/assignments/flowers.jpg');
A = rgb2gray(im2double(f));

% Use nlfilter - only works on grayscale
fun = @(x) mean(x(:));

B = nlfilter(A,[25 25],fun);
subplot(211)
imshow(A)
subplot(212)
imshow(B);

%% imfilter

f = imread('/Users/akanwar/Documents/Image Processing course/assignments/flowers.jpg');

% H = fspecial('average',HSIZE) returns an averaging filter H of size
%     HSIZE. HSIZE can be a vector specifying the number of rows and columns in
%     H or a scalar, in which case H is a square matrix.
%     The default HSIZE is [3 3]

H = fspecial('average', 10);
filteredRGB = imfilter(f,H);

subplot(211), imshow(f), subplot(212), imshow(filteredRGB)
boundaryReplicateRGB = imfilter(f,h,'replicate'); 
figure, imshow(boundaryReplicateRGB)


%% brute force
% not implemented yet
% % get the number of rows, columns and bands
[r, c, b] = size(im);       

% output image will be same size as input - preallocate
outImage = zeros(r, c, b);

% Assumption is that the neighbourhood is square
filterSize = 25;

% compute midlength of filter
mid = (filterSize - 1)/2;

for band=1:b
    for nRow=1:25
        for nCol=1:25
            avgPixValue = 0;
            position = 0;
            for x = (nCol - mid):(nCol + mid)
                if x < 1 || x > c
                    % If these values exceed the boundary ignore
                    continue                    
                end              
                for y = (nRow - mid):(nRow + mid)
                    if y < 1 || y > r
                        % If these values exceed the boundary ignore
                        continue                    
                    end                                       
                    avgPixValue = im(y, x, band);
                end     
            end
            outImg(nRow, nCol, band) = avgPixValue;
        end
    end
end
subplot(311)
imshow(im)
subplot(312)
imshow(outImg)
subplot(313)
% imshow(outImg - im)

%% imrotate

f = imread('/Users/akanwar/Documents/Image Processing course/assignments/flowers.jpg');
R = imrotate(f, 45);

H = fspecial('average', 10);
rF = imfilter(R,H);
imshow(rF)


end

