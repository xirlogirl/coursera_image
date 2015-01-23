% JPEG baseline quantization matrix

I = imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.tiff');

I = imread('lena.tiff');
quality = 16;


Q = [16,11,10,16,24,40,51,61;...
    12,12,14,19,26,58,60,55;...
    14,13,16,24,40,57,69,56;...
    14,17,22,29,51,87,80,62;...
    18,22,37,56,68,109,103,77;...
    24,35,55,64,81,104,113,92;...
    49,64,78,87,103,121,120,101;...
    72,92,95,98,112,100,103,99]; 

 
% First DCT -------
% create function handle for 2D DCT - input to blockproc
dct = @(block_struct) dct2(block_struct.data);


% divide the image into non-overlapping 8x8 blocks, compute the 2D dct of each
I2 = blockproc(rgb2gray(I), [8 8], dct);
 
% Quantize each block
quantize = @(block_struct) round(block_struct.data./(quality*Q));
I3 = blockproc(I2, [8 8], quantize);
 
% Invert - 1st reconstruct
reconstruct =  @(block_struct) block_struct.data.*Q;
R1 = blockproc(I3, [8 8], reconstruct);
 

% 2nd - Now out of the transform domain
invtrans =  @(block_struct) idct2(block_struct.data);
R2 = blockproc(R1, [8 8], invtrans);

 

subplot(121); imshow(R2, []), title('DCT'); hold on


% FFT ------- same as above but with FFT
fft = @(block_struct) fft2(block_struct.data);

% divide the image into non-overlapping 8x8 blocks, compute the 2D dct of each
I2 = blockproc(rgb2gray(I), [8 8], fft);

  

% Quantize each block
I3 = blockproc(I2, [8 8], quantize);
 

% Invert - 1st reconstruct-- not sure if this is necessary
reconstruct =  @(block_struct) round(block_struct.data.*Q);

R1 = blockproc(I3, [8 8], reconstruct);

 

% 2nd - Now out of the trnasform domain

invtrans =  @(block_struct) ifft2(block_struct.data);
R2 = blockproc(R1, [8 8], invtrans);


subplot(122); imshow(R2, []), title('FFT')