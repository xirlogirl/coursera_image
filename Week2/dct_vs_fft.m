%% JPEG implementation in grayscale
clear
I = double(rgb2gray(imread('/Users/akanwar/Documents/Image Processing course/assignments/lena.tiff')));

% on second thought - this exercise does not make sense with the quality
% factor considered. I think the point is to see the difference between DCT
% and FFT, in particular how DCT behaves better at the boundaries.
% DCT is essentially the real part of the FFT. In the code below the phase
% is not considered (only plots the real part- which is amplitude)
% I did an FFT shift to try and shift the spectrum to 0 and eliminate the complex/
% phase component. and the image quality appears identical (though the
% quadrants are all flipped). There is still an imaginary component so I
% don't know if its 100% correct. I think what you need to do is
% incorporate the phase information to show that DCT is superior to FFT for
% image compression.
%
% If you were to incorporate the phase information then you would probably
% see that DCT is superior to FFT.
% DCT has a 2n point periodicity whereas the DFT shows the Gibbs phenomenon
% which causes the boundary points to take son erroneous values.
% In the case where you only consider the
% real part of FFT, they are pretty much equivalent. 

% Update: tried to shift the FFT so that there is no phase
% component/imaginary. FFT compression looks funny, probably not correct,
% but perhaps somewhat representative?

% Update: sclaed the baseline matrix by 8. better now.
% The difference is caused by the different scaling factors 
% used for DFT and DCT(a bit strange why different convention is used)
% fft2(ones(8))  is an almost 0 matrix except FFT2(1,1)=64
% dct2( ones(8) )    is an almost 0 matrix except DCT2(1,1)=8
% The DCT2 coefficient is 8 times smaller than for FFT, so for 
% a comparable result the quantizing matrix should be 8 times bigger for fft.

quality = 10;

% JPEG baseline quantization matrix
Q = [16,11,10,16,24,40,51,61;
    12,12,14,19,26,58,60,55;
    14,13,16,24,40,57,69,56;
    14,17,22,29,51,87,80,62;
    18,22,37,56,68,109,103,77;
    24,35,55,64,81,104,113,92;
    49,64,78,87,103,121,120,101;
    72,92,95,98,112,100,103,99] * quality ;



order = [1 9 2 3 10 17 25 18 11 4 5 12 19 26 33  ...
         41 34 27 20 13 6 7 14 21 28 35 42 49 57 50 ...
         43 36 29 22 15 8 16 23 30 37 44 51 58 59 52 ...
         45 38 31 24 32 39 46 53 60 61 54 47 40 48 55 ...
         62 63 56 64];

zonal_mask = ones(size(Q));     
     
% create function handle for 2D DCT - input to blockproc
% eg. resizer would be fun = @(block_struct) imresize(block_struct.data,0.15);
% eg. then I2 = blockproc(I,[100 100],fun);
% Need to perform level shifting prior to DCT
lshift = @(block_struct) block_struct.data - 2^7; %(for an 8 bit image)
lshift2 = @(block_struct) block_struct.data + 2^7;

fdct = @(block_struct) dct2(block_struct.data);
quantize = @(block_struct) fix(block_struct.data./Q);
reconstruct =  @(block_struct) fix(block_struct.data).*Q;
invdct =  @(block_struct) idct2(block_struct.data);

% divide the image into non-overlapping 8x8 blocks, compute the 2D dct of each
I2 = blockproc(I, [8 8], lshift);
I3 = blockproc(I2, [8 8], fdct); 
% Quantize each block
I4 = blockproc(I3, [8 8], quantize);%--- up to here looks ok
% Invert - 1st reconstruct - this step looks to be wrong should reproduce I3 here 
R1 = blockproc(I4, [8 8], reconstruct);
% 2nd - Now out of the DCT  domain
R2 = blockproc(R1, [8 8], invdct);
R3 = blockproc(R2, [8 8], lshift2);


subplot(121); imshow(R3, []), title('DCT'); hold on

% create function handle for 2D DCT - input to blockproc
% redefine the transform functions only - quanitiztion remians the same as
% DCT
f_fft = @(block_struct) fft2(block_struct.data);
invfft =  @(block_struct) ifft2(block_struct.data);
shift = @(block_struct) fftshift(block_struct.data);

%level shift? for fft?
%F2 = blockproc(I, [8 8], lshift);

% divide the image into non-overlapping 8x8 blocks, compute the 2D dct of each
F1 = blockproc(I, [8 8], f_fft); 
% Quantize each block
F2 = blockproc(F1, [8 8], quantize);
F3 = F2/8;
% Invert - 1st reconstruct
RF1 = blockproc(F3, [8 8], reconstruct);
% 2nd - Now out of the trnasform domain
RF2 = blockproc(RF1, [8 8], invfft);


%RF2 = blockproc(RF1, [8 8], lshift2);

%RF4 = blockproc(RF3, [8 8], shift);





subplot(122); imshow(RF2, []), title('FFT')