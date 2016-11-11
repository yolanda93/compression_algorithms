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
imshow(sub12,[0,255])
subplot(4,4,5)
imshow(sub13,[0,255])
subplot(4,4,6)
imshow(sub14,[0,255])
% Now for the bigger subbands we are going to use bigger subplots
subplot(4,4,[3:4 7:8])
imshow(sub21,[0,255])
subplot(4,4,[9:10 13:14])
imshow(sub22,[0,255])
subplot(4,4,[11:12 15:16])
imshow(sub23,[0,255])

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
for i= 7:-1:1
    q_sub11 = quantize_matrix(sub11,8);
    q_sub12 = quantize_matrix(sub12,i);
    q_sub13 = quantize_matrix(sub13,i);
    q_sub14 = quantize_matrix(sub14,i);
    q_sub21 = quantize_matrix(sub21,i);
    q_sub22 = quantize_matrix(sub22,i);
    q_sub23 = quantize_matrix(sub23,i);
    e_sub11 = shannonEntropy(q_sub11);
    e_sub12 = shannonEntropy(q_sub12);
    e_sub13 = shannonEntropy(q_sub13);
    e_sub14 = shannonEntropy(q_sub14);
    e_sub21 = shannonEntropy(q_sub21);
    e_sub22 = shannonEntropy(q_sub22);
    e_sub23 = shannonEntropy(q_sub23);
    q_lena = quantize_matrix(lena_haar,i);
    q_lena(1:128,1:128) = q_sub11;
    e_lena = shannonEntropy(q_lena);
    dict = huffmanDict(q_lena);
    sizeMap = containers.Map('KeyType','double', 'ValueType','any');
    for row = 1:size(dict,1)
        keyCell = dict(row,1);
        valueCell = dict(row,2);
        code = valueCell{1};
        key = keyCell{1};
        sizeMap(key) = size(code,2);
    end
    %SizeMap holds the lengths of all the symbols
    % TODO subtitute the symbols by their length and add all the elements
    % of the matrix, then divide by the nuelem of the matrix
    entropies(i,:) = [e_sub11, e_sub12, e_sub13, e_sub14, e_sub21, e_sub22, e_sub23, e_lena];
end 
entropies


