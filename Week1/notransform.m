% Dont use any transform

quality = 1;

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
%lshift = @(block_struct) block_struct.data - 2^7; %(for an 8 bit image)
%lshift2 = @(block_struct) block_struct.data + 2^7;


quantize = @(block_struct) fix(block_struct.data./Q);
reconstruct =  @(block_struct) fix(block_struct.data).*Q;


% Quantize each block
I1 = blockproc(I, [8 8], quantize);
% Invert - 1st reconstruct - this step looks to be wrong should reproduce I3 here 
R1 = blockproc(I4, [8 8], reconstruct);



subplot(121); imshow(I, []), title('Original'); hold on
subplot(122); imshow(R1, []), title('No transform'); hold on

