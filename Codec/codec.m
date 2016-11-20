% Part 3. Implementation of a codec
% 1. Load image/lena_gray_512.tif
% Use the double haar transform.
lena_haar = haar_transform_multilevel(lena_gray_512,2);
% Let's see the histogram for each sub-band
% First we divide the matrix into submatrices
% We have 3x3 sub-bands
sub11 = lena_haar(1:128,1:128);
sub12 = lena_haar(1:128,129:256);
sub13 = lena_haar(129:256,1:128);
sub14 = lena_haar(129:256,129:256);
sub21 = lena_haar(1:256,257:512);
sub22 = lena_haar(257:512,1:256);
sub23 = lena_haar(257:512,257:512);
figure
subplot(4,4,1)
imshow(sub11,[0,255])
subplot(4,4,2)
imshow(sub12)
subplot(4,4,5)
imshow(sub13)
subplot(4,4,6)
imshow(sub14)
% Now for the bigger subbands we are going to use bigger subplots
subplot(4,4,[3:4 7:8])
imshow(sub21)
subplot(4,4,[9:10 13:14])
imshow(sub22)
subplot(4,4,[11:12 15:16])
imshow(sub23)

% We are going to use the same subplot distribution to show the histogram
% of each sub image
% Since imhist only uses values from 0 to 1,
% we need to move everything 256 values up (to make the negative numbers)
% possitive and then divide by 512 to obtain values from 0 to 1.
% In this scale, the old 0 is at 0.5, -255 at 0 and 255 at 1.
figure
subplot(4,4,1)
imhist((sub11+255)./512)
subplot(4,4,2)
imhist((sub12+255)./512)
subplot(4,4,5)
imhist((sub13+255)./512)
subplot(4,4,6)
imhist((sub14+255)./512)
% Now for the bigger subbands we are going to use bigger subplots
subplot(4,4,[3:4 7:8])
imhist((sub21+255)./512)
subplot(4,4,[9:10 13:14])
imhist((sub22+255)./512)
subplot(4,4,[11:12 15:16])
imhist((sub23+255)./512)

% After looking at the distribution of data, we should use a non-uniform
% scalar quantizer and with a smaller quantization step around 0, but since
% we only have a uniform scalar quantizer, we will use that.
% No Quantization for the ll part of the image (sub 11)

% Need to count all the appearances of each number
entropies = zeros(7,8);
q_sub11 = sub11;
q_sub12 = quantize_matrix(sub12,7);
q_sub13 = quantize_matrix(sub13,7);
q_sub14 = quantize_matrix(sub14,6);
q_sub21 = quantize_matrix(sub21,5);
q_sub22 = quantize_matrix(sub22,5);
q_sub23 = quantize_matrix(sub23,4);

e_sub11 = shannonEntropy(q_sub11);
h_sub11 = numel(huffmanCode(q_sub11))/numel(q_sub11);

e_sub12 = shannonEntropy(q_sub12);
h_sub12 = numel(huffmanCode(q_sub12))/numel(q_sub12);

e_sub13 = shannonEntropy(q_sub13);
h_sub13 = numel(huffmanCode(q_sub13))/numel(q_sub13);

e_sub14 = shannonEntropy(q_sub14);
h_sub14 = numel(huffmanCode(q_sub14))/numel(q_sub14);

e_sub21 = shannonEntropy(q_sub21);
h_sub21 = numel(huffmanCode(q_sub21))/numel(q_sub21);

e_sub22 = shannonEntropy(q_sub22);
h_sub22 = numel(huffmanCode(q_sub22))/numel(q_sub22);

e_sub23 = shannonEntropy(q_sub23);
h_sub23 = numel(huffmanCode(q_sub23))/numel(q_sub23);

% We need to "stitch" all the pieces of q_lena together
q_lena = zeros(size(lena_gray_512,1),size(lena_gray_512,2));
q_lena(1:128,1:128) = q_sub11;
q_lena(1:128,129:256) = q_sub12;
q_lena(129:256,1:128) = q_sub13;
q_lena(129:256,129:256) = q_sub14;
q_lena(1:256,257:512) = q_sub21;
q_lena(257:512,1:256) = q_sub22;
q_lena(257:512,257:512) = q_sub23;
e_lena = shannonEntropy(q_lena);
h_lena = numel(huffmanCode(q_lena))/numel(q_lena); %q_lena in huffman code

entropies = [e_sub11, e_sub12, e_sub13, e_sub14, e_sub21, e_sub22, e_sub23, e_lena;
            h_sub11, h_sub12, h_sub13, h_sub14, h_sub21, h_sub22, h_sub23, h_lena]';
 
entropies
compression_rates = 8./entropies; %original image has 8 bpp
compression_rates

%%%%%%%% SYNTHESIS %%%%%%%%%%%%%
dq_lena = zeros(size(lena_gray_512,1),size(lena_gray_512,2));
dq_lena(1:128,1:128) = q_lena(1:128,1:128);
dq_lena(1:128,129:256) = dequantize_matrix(q_lena(1:128,129:256),7,8);
dq_lena(129:256,1:128) = dequantize_matrix(q_lena(129:256,1:128),7,8);
dq_lena(129:256,129:256) = dequantize_matrix(q_lena(129:256,129:256),6,8);
dq_lena(1:256,257:512) = dequantize_matrix(q_lena(1:256,257:512),5,8);
dq_lena(257:512,1:256) = dequantize_matrix(q_lena(257:512,1:256),5,8);
dq_lena(257:512,257:512) = dequantize_matrix(q_lena(257:512,257:512),4,8);

synth_lena = haar_reverse_multilevel(dq_lena,2);
figure
imshow(synth_lena,[0,255])

%%%%%%%% PSNR calculation %%%%%%%%
[PSNR,MSE,MAXERR,L2RAT] = measerr(lena_gray_512,synth_lena);
% measerr already provides the PSNR but we can calculate it again using the
% formula: 10 * log10((255^2)/MSE)
PSNR_2 = 10 * log10((255^2)/MSE);
% Which gives the exact same result
[PSNR, PSNR_2]

% END OF FILE