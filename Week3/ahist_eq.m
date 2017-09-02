% Implement a histogram equalization function. If using Matlab, compare 
% your implementation with Matlab?s built-in function.

%function y = ahist_eq(I)

% qualizes the histogram of an input image
clear
I = rgb2gray(imread('/Users/akanwar/Documents/Image Processing course/assignments/faded_image.jpg'));

% wikipedia mini image
% I = [ 52, 55, 61, 66, 70, 61, 64, 73;
% 63, 59, 55, 90, 109, 85, 69, 72;
% 62,59,68,113,144,104,66,73;
% 63,58,71,122,154,106,70,69;
% 67,61,68,104,126,88,68,70;
% 79,65,60,70,77,68,58,75;
% 85,71,64,59,55,61,65,83;
% 87,79,69,68,65,76,78,94];


[m, n] = size(I);

L = 256; % for an 8 bit image


[nk, edges] = histcounts(I, L-1);

% compute probabilities of each bin
% This is pr(r) of gonzales woods
pr = nk/(m*n);

% Probability distribution function
pdf = cumsum(pr);
%cdf= cumsum(nk); 

% TO scale such that the first value on the original array goes to 0
%cdf = cdf-cdf(1);
pdf = pdf-pdf(1);

% Transfer function
%  Eq 3.3-8 of Gonzales & Woods 3ed.
% (L-1)/ sum(n_j) from j to k where k = 0, 1, 2... L-1
% or (L-1)/(MN)/ sum(r_j)
s = round((L-1)*pdf);


% Now s is the transform function T(r)
% Find the original grayscale value and where it 'ranked' in the orginal histogram
% Then, plug the index into T(r) to get the new pixel value
% minimum value of J should go to 0 and max should go to 255
 
J = zeros(m,n,'uint8');
for row =1:m;
    for col = 1:n;
        ind = find(I(row,col)==round(edges),1);
        J(row,col) = s(ind);
    end
end


% %figure; subplot(121); hist(I); subplot(122); hist(J)
figure; subplot(321); imshow(I,[0 255]); title('Original'); subplot(322); imshow(J,[0 255]); title('Equalized')
subplot(323); imhist(I); subplot(324); imhist(J);
subplot(325); plot(pdf,'k'); xlim([0 255]); title('Input PDF'); subplot(326); plot(s,'k'); xlim([0 255]); title('Transfer function')
%subplot imshow(I,[0 255])

% Compare to MATLAB
K = histeq(I);
figure; subplot(211); imshow(K); title('MATLAB implementation'); subplot(212); imshow(J-K,[]); title('Diff AK-MATLAB')