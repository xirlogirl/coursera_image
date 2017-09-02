% Implement a median filter. Add different levels and types of noise to an 
% image and experiment with different sizes of support for the median 
% filter. As before, compare your implementation with Matlab?s.

% DONE, looks correct

clear
%I = imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.gif');
I = imread('cameraman.tif');
[m, n] = size(I);


J = zeros(size(I));
for row=1:m
    for col=1:n
        if row == 1 || col == 1 || row == m || col ==n
            J(row,col)=I(row,col);
        else 
            values = I(row-1:row+1,col-1:col+1);
            J(row,col) = median(reshape(values, [1 9]));
        end
    end
end


figure; subplot(211); imshow(I,[]); subplot(212), imshow(J,[])

A = imread('cameraman.tif');
fun = @(x) median(x(:));
B = nlfilter(A,[3 3],fun);
figure; subplot(211); imshow(A); subplot(212);  imshow(B)
