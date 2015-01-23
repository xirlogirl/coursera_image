% (Optional programming exercises)
% Do a basic implementation of JPEG.
% Divide the image into non-overlapping 8x8 blocks.
% Compute the DCT (discrete cosine transform) of each block. This is implemented in popular packages such as Matlab.
% Quantize each block. You can do this using the tables in the video or simply divide each coefficient by N, 
% round the result to the nearest integer, 
% and multiply back by N. Try for different values of N. You can also try preserving the 8 largest coefficients 
% (out of the total of 8x8=64), and simply rounding them to the closest integer.
% Visualize the results after you invert the quantization and the DCT.

% Repeat the above but instead of using the DCT, use the FFT (Fast Fourier Transform).
% Repeat the above JPEG-type compression but don?t use any transform, simply perform quantization on the original image.
% Do JPEG now for color images. In Matlab, use the rgb2ycbcr command to convert the Red-Green-Blue image to a Lumina and Chroma one; 
% then perform the JPEG-style compression on each one of the three channels independently. 
% After inverting the compression, invert the color transform and visualize the result. While keeping the compression 
% ratio constant for the Y channel, increase the compression of the two chrominance channels and observe the results.
% Compute the histogram of a given image and of its prediction errors. If the pixel being processed is at coordinate (0,0), consider
% predicting based on just the pixel at (-1,0);
% predicting based on just the pixel at (0,1);
% predicting based on the average of the pixels at (-1,0), (-1,1), and (0,1).
% Compute the entropy for each one of the predictors in the previous exercise. Which predictor will compress better?

% Possibly too big
%f = imread('/Users/akanwar/Documents/Image Processing course/sample image/191_SEG001/191__MRC-00003299__SEG-001__20140701_155712Z_ORT_16_02820307.TIF');

%% JPEG implementation in grayscale
I = imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.tiff');

% JPEG baseline quantization matrix
Q = [16,11,10,16,24,40,51,61;...
    12,12,14,19,26,58,60,55;...
    14,13,16,24,40,57,69,56;...
    14,17,22,29,51,87,80,62;...
    18,22,37,56,68,109,103,77;...
    24,35,55,64,81,104,113,92;...
    49,64,78,87,103,121,120,101;...
    72,92,95,98,112,100,103,99]; 

% create function handle for 2D DCT - input to blockproc
% eg. resizer would be fun = @(block_struct) imresize(block_struct.data,0.15);
% eg. then I2 = blockproc(I,[100 100],fun);
dct = @(block_struct) dct2(block_struct.data);

% divide the image into non-overlapping 8x8 blocks, compute the 2D dct of each
I2 = blockproc(rgb2gray(I), [8 8], dct);

quality = 16;
 
% Quantize each block
quantize = @(block_struct) round(block_struct.data./(Q));
I3 = blockproc(I2, [8 8], quantize);

% Invert - 1st reconstruct
reconstruct =  @(block_struct) block_struct.data.*(Q*quality);
R1 = blockproc(I3, [8 8], reconstruct);

% 2nd - Now out of the trnasform domain
invtrans =  @(block_struct) idct2(block_struct.data);
R2 = blockproc(R1, [8 8], invtrans);

subplot(121); imshow(R2, []), title('DCT'); hold on

%% jpeg implementaion with FFT instead of DCT

% may not be correct, see other code. lots of things not considered here.
% - level shifting for jpeg, and the phase (imaginary) component of fft.

I = imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.tiff');

quality = 16;

% JPEG baseline quantization matrix
Q = [16,11,10,16,24,40,51,61;...
    12,12,14,19,26,58,60,55;...
    14,13,16,24,40,57,69,56;...
    14,17,22,29,51,87,80,62;...
    18,22,37,56,68,109,103,77;...
    24,35,55,64,81,104,113,92;...
    49,64,78,87,103,121,120,101;...
    72,92,95,98,112,100,103,99]; 

% create function handle for 2D DCT - input to blockproc
% eg. resizer would be fun = @(block_struct) imresize(block_struct.data,0.15);
% eg. then I2 = blockproc(I,[100 100],fun);
fft = @(block_struct) fft2(block_struct.data);
quantize = @(block_struct) round(block_struct.data./(Q));
reconstruct =  @(block_struct) round(block_struct.data .*Q);
invtrans =  @(block_struct) ifft2(block_struct.data);

% divide the image into non-overlapping 8x8 blocks, compute the 2D dct of each
I2 = blockproc(rgb2gray(I), [8 8], fft);
 
% Quantize each block

I3 = blockproc(I2, [8 8], quantize);

% Invert - 1st reconstruct
R1 = blockproc(I3, [8 8], reconstruct);

% 2nd - Now out of the trnasform domain
R2 = blockproc(I3, [8 8], invtrans);

subplot(122); imshow(R2, []), title('FFT')

%% jpeg implementation in RGB
% Do JPEG now for color images. In Matlab, use the rgb2ycbcr command to convert the Red-Green-Blue image to a Lumina and Chroma one; 
% then perform the JPEG-style compression on each one of the three channels independently. 
% After inverting the compression, invert the color transform and visualize the result. While keeping the compression 
% ratio constant for the Y channel, increase the compression of the two chrominance channels and observe the results.

I = imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.tiff');

%I = imread('lena.tiff');

% JPEG baseline quantization matrix
Q = [16,11,10,16,24,40,51,61;...
    12,12,14,19,26,58,60,55;...
    14,13,16,24,40,57,69,56;...
    14,17,22,29,51,87,80,62;...
    18,22,37,56,68,109,103,77;...
    24,35,55,64,81,104,113,92;...
    49,64,78,87,103,121,120,101;...
    72,92,95,98,112,100,103,99]; 

% convert to ycbcr space
I_ycbcr = rgb2ycbcr(I);
% get number of spaces
[~, ~, N] = size(I_ycbcr);

% convert to double [0 1]..?
I2 = double(I_ycbcr);

quality = 2;

% create function handle for use later
dct = @(block_struct) dct2(block_struct.data);
quantize = @(block_struct) round(block_struct.data./(Q*quality));
reconstruct =  @(block_struct) round(block_struct.data.*(Q*quality));
invtrans =  @(block_struct) idct2(block_struct.data);

% Loop over each channel - Perform the dct, quantization, and inverse
% operations
for i=1:N
    % divide the image into non-overlapping 8x8 blocks, compute the 2D dct of each
    I3(:,:,i) = blockproc(I2(:,:,i), [8 8], dct);

    %Quantize each block
    I4(:,:,i) = blockproc(I3(:,:,i), [8 8], quantize);

    % Invert - First, reconstruct
    R1(:,:,i) = blockproc(I4(:,:,i), [8 8], reconstruct);

    % 2nd - Now out of the trnasform domain
    R2(:,:,i) = blockproc(R1(:,:,i), [8 8], invtrans);
end

% Convert back to RGB, and uint8
R3 = ycbcr2rgb(uint8(R2));
IM = (uint8(I));
subplot(121); imshow(IM); title('original image')
subplot(122); imshow(R3); title('RGB reconstruction');



%% jpeg implementation in RGB -- increase compression factor
% Do JPEG now for color images. In Matlab, use the rgb2ycbcr command to convert the Red-Green-Blue image to a Lumina and Chroma one; 
% then perform the JPEG-style compression on each one of the three channels independently. 
% After inverting the compression, invert the color transform and visualize the result. While keeping the compression 
% ratio constant for the Y channel, increase the compression of the two chrominance channels and observe the results.

I = imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.tiff');

%I = imread('lena.tiff');

% JPEG baseline quantization matrix
Q = [16,11,10,16,24,40,51,61;...
    12,12,14,19,26,58,60,55;...
    14,13,16,24,40,57,69,56;...
    14,17,22,29,51,87,80,62;...
    18,22,37,56,68,109,103,77;...
    24,35,55,64,81,104,113,92;...
    49,64,78,87,103,121,120,101;...
    72,92,95,98,112,100,103,99]; 

% convert to ycbcr space
I_ycbcr = rgb2ycbcr(I);
% get number of spaces
[~, ~, N] = size(I_ycbcr);

% convert to double [0 1]..?
I2 = double(I_ycbcr);

quality = 2;

% create function handle for use later
dct = @(block_struct) dct2(block_struct.data);
invtrans =  @(block_struct) idct2(block_struct.data);

% Loop over each channel - Perform the dct, quantization, and inverse
% operations
for i=1:N
    if i ~=1
        quality = 16;        
    end 
    quantize = @(block_struct) round(block_struct.data./(Q*quality));
    reconstruct =  @(block_struct) round(block_struct.data.*(Q*quality));
    i
    quality
    % divide the image into non-overlapping 8x8 blocks, compute the 2D dct of each
    I3(:,:,i) = blockproc(I2(:,:,i), [8 8], dct);

    %Quantize each block
    I4(:,:,i) = blockproc(I3(:,:,i), [8 8], quantize);

    % Invert - First, reconstruct
    R1(:,:,i) = blockproc(I4(:,:,i), [8 8], reconstruct);

    % 2nd - Now out of the trnasform domain
    R2(:,:,i) = blockproc(R1(:,:,i), [8 8], invtrans);
end

% Convert back to RGB, and uint8
R3 = ycbcr2rgb(uint8(R2));
IM = (uint8(I));
subplot(121); imshow(IM); title('original image')
subplot(122); imshow(R3); title('RGB reconstruction');


%% Prediction stuff
% Error is very focused so you can use a smaller number of bits to encode
% error rather than pixel value

I = imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.tiff');
imhist(rgb2gray(I))

m =1; % first order predictor


