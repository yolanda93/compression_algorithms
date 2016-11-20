[img1, colormap] = imread('../Test-images/stereoscopy-images/image3.jpg');
figure; image(img1), title('Original Image'); % Original image

%  Split them into 2 separate images
leftImage = img1(:,1:(end/2),:);

rightImage = img1(:,end/2+1:end,:);
figure; image(leftImage), title('Left Image');
figure; image(rightImage), title('Right Image');

leftImage = paddingZeros(leftImage,4); %We need a dimension divisible by 4
rightImage = paddingZeros(rightImage,4);


% Encode each eye's image using filters of different (usually chromatically opposite) colors, red and blue
r = zeros(size(leftImage));
gb = zeros(size(rightImage));
r(:,:,1) = double(leftImage(:,:,1));
gb(:,:,2:3) = double(rightImage(:,:,2:3));
anaglyph = uint8(r+gb);
figure,image(uint8(r)), title('Red')
figure,image(uint8(gb)), title('Cyan')
figure,image(anaglyph), title('My Anaglyph')

% Create stereo anaglyph with Matlab function to check the result
J = stereoAnaglyph(leftImage,rightImage);
figure, image(uint8(J)), title('Anaglyph using Matlab function')

% Use TD3 to code them using 2 decomposition layers
leftImage_haar = zeros(size(r,1),size(r,2),size(r,3));
rightImage_haar =zeros(size(gb,1),size(gb,2),size(gb,3));
rows_l=size(leftImage,1);
rows_r=size(rightImage,1);
cols_l=size(leftImage,2);
cols_r=size(rightImage,2);
sub11_l = zeros(rows_l/4,cols_l/4,3); sub11_r = zeros(rows_r/4,cols_r/4,3);
sub12_l = zeros(rows_l/4,cols_l/4,3); sub12_r = zeros(rows_r/4,cols_r/4,3);
sub13_l = zeros(rows_l/4,cols_l/4,3); sub13_r = zeros(rows_r/4,cols_r/4,3);
sub14_l = zeros(rows_l/4,cols_l/4,3); sub14_r = zeros(rows_r/4,cols_r/4,3);
sub21_l = zeros(rows_l/2,cols_l/2,3); sub21_r = zeros(rows_r/2,cols_r/2,3);
sub22_l = zeros(rows_l/2,cols_l/2,3); sub22_r = zeros(rows_r/2,cols_r/2,3);
sub23_l = zeros(rows_l/2,cols_l/2,3); sub23_r = zeros(rows_r/2,cols_r/2,3);

for i=1:3
   % temp = leftImage(:,:,i);
    temp = r(:,:,i);

    leftImage_haar(:,:,i) = haar_transform_multilevel(temp,2);

    sub11_l(:,:,i) = leftImage_haar(1:rows_l/4, 1:cols_l/4,i);
    sub12_l(:,:,i) = leftImage_haar(1:rows_l/4, cols_l/4+1:cols_l/2,i);
    sub13_l(:,:,i) = leftImage_haar(rows_l/4+1:rows_l/2, 1:cols_l/4,i);
    sub14_l(:,:,i) = leftImage_haar(rows_l/4+1:rows_l/2, cols_l/4+1:cols_l/2,i);
    sub21_l(:,:,i) = leftImage_haar(1:rows_l/2, cols_l/2+1:cols_l,i);
    sub22_l(:,:,i) = leftImage_haar(rows_l/2+1:rows_l, 1:cols_l/2,i);
    sub23_l(:,:,i) = leftImage_haar(rows_l/2+1:rows_l, cols_l/2+1:cols_l,i);

    temp2 = gb(:,:,i);
    rightImage_haar(:,:,i) = haar_transform_multilevel(temp2,2);
    sub11_r(:,:,i) = rightImage_haar(1:rows_l/4, 1:cols_l/4,i);
    sub12_r(:,:,i) = rightImage_haar(1:rows_l/4, cols_l/4+1:cols_l/2,i);
    sub13_r(:,:,i) = rightImage_haar(rows_l/4+1:rows_l/2, 1:cols_l/4,i);
    sub14_r(:,:,i) = rightImage_haar(rows_l/4+1:rows_l/2, cols_l/4+1:cols_l/2,i);
    sub21_r(:,:,i) = rightImage_haar(1:rows_l/2, cols_l/2+1:cols_l,i);
    sub22_r(:,:,i) = rightImage_haar(rows_l/2+1:rows_l, 1:cols_l/2,i);
    sub23_r(:,:,i) = rightImage_haar(rows_l/2+1:rows_l, cols_l/2+1:cols_l,i);
end
figure;image(uint8(leftImage_haar));title('Left Image after haar filter');
figure;image(uint8(rightImage_haar));title('Right Image after haar filter');

% With more detail
figure
subplot(4,4,1)
image(sub11_l./255)
subplot(4,4,2)
image(sub12_l)
subplot(4,4,5)
image(sub13_l)
subplot(4,4,6)
image(sub14_l)
% Now for the bigger subbands we are going to use bigger subplots
subplot(4,4,[3:4 7:8])
image(sub21_l)
subplot(4,4,[9:10 13:14])
image(sub22_l)
subplot(4,4,[11:12 15:16])
image(sub23_l)

% With more detail
figure
subplot(4,4,1)
image(sub11_r./255)
subplot(4,4,2)
image(sub12_r)
subplot(4,4,5)
image(sub13_r)
subplot(4,4,6)
image(sub14_r)
% Now for the bigger subbands we are going to use bigger subplots
subplot(4,4,[3:4 7:8])
image(sub21_r)
subplot(4,4,[9:10 13:14])
image(sub22_r)
subplot(4,4,[11:12 15:16])
image(sub23_r)

leftImage_dq = zeros(size(leftImage,1),size(leftImage,2),size(leftImage,3));
leftImage_synth = zeros(size(leftImage,1),size(leftImage,2),size(leftImage,3));

rightImage_dq =zeros(size(rightImage,1),size(rightImage,2),size(rightImage,3));
rightImage_synth = zeros(size(rightImage,1),size(rightImage,2),size(rightImage,3));

for i=1:3
    q_sub11_l(:,:,i) = sub11_l(:,:,i);
    q_sub12_l(:,:,i) = quantize_matrix(sub12_l(:,:,i),4);
    q_sub13_l(:,:,i) = quantize_matrix(sub13_l(:,:,i),4);
    q_sub14_l(:,:,i) = quantize_matrix(sub14_l(:,:,i),4);
    q_sub21_l(:,:,i) = quantize_matrix(sub21_l(:,:,i),3);
    q_sub22_l(:,:,i) = quantize_matrix(sub22_l(:,:,i),3);
    q_sub23_l(:,:,i) = quantize_matrix(sub23_l(:,:,i),3);

    q_sub11_r(:,:,i) = sub11_r(:,:,i);
    q_sub12_r(:,:,i) = quantize_matrix(sub12_r(:,:,i),4);
    q_sub13_r(:,:,i) = quantize_matrix(sub13_r(:,:,i),4);
    q_sub14_r(:,:,i) = quantize_matrix(sub14_r(:,:,i),4);
    q_sub21_r(:,:,i) = quantize_matrix(sub21_r(:,:,i),3);
    q_sub22_r(:,:,i) = quantize_matrix(sub22_r(:,:,i),3);
    q_sub23_r(:,:,i) = quantize_matrix(sub23_r(:,:,i),3);
    
    %Synthesis
    leftImage_dq(1:rows_l/4, 1:cols_l/4,i)= q_sub11_l(:,:,i);
    leftImage_dq(1:rows_l/4, cols_l/4+1:cols_l/2,i) = dequantize_matrix(q_sub12_l(:,:,i),4,8);
    leftImage_dq(rows_l/4+1:rows_l/2, 1:cols_l/4,i) = dequantize_matrix(q_sub13_l(:,:,i),4,8);
    leftImage_dq(rows_l/4+1:rows_l/2, cols_l/4+1:cols_l/2,i) = dequantize_matrix(q_sub14_l(:,:,i),4,8);
    leftImage_dq(1:rows_l/2, cols_l/2+1:cols_l,i) = dequantize_matrix(q_sub21_l(:,:,i),3,8);
    leftImage_dq(rows_l/2+1:rows_l, 1:cols_l/2,i) = dequantize_matrix(q_sub22_l(:,:,i),3,8);
    leftImage_dq(rows_l/2+1:rows_l, cols_l/2+1:cols_l,i) = dequantize_matrix(q_sub23_l(:,:,i),4,8);
    leftImage_synth(:,:,i) = haar_reverse_multilevel(leftImage_dq(:,:,i),2);

    rightImage_dq(1:rows_r/4, 1:cols_r/4,i)= q_sub11_r(:,:,i);
    rightImage_dq(1:rows_r/4, cols_r/4+1:cols_r/2,i) = dequantize_matrix(q_sub12_r(:,:,i),4,8);
    rightImage_dq(rows_r/4+1:rows_r/2, 1:cols_r/4,i) = dequantize_matrix(q_sub13_r(:,:,i),4,8);
    rightImage_dq(rows_r/4+1:rows_r/2, cols_r/4+1:cols_r/2,i) = dequantize_matrix(q_sub14_r(:,:,i),4,8);
    rightImage_dq(1:rows_r/2, cols_r/2+1:cols_r,i) = dequantize_matrix(q_sub21_r(:,:,i),3,8);
    rightImage_dq(rows_r/2+1:rows_r, 1:cols_r/2,i) = dequantize_matrix(q_sub22_r(:,:,i),3,8);
    rightImage_dq(rows_r/2+1:rows_r, cols_r/2+1:cols_r,i) = dequantize_matrix(q_sub23_r(:,:,i),4,8);
    rightImage_synth(:,:,i) = haar_reverse_multilevel(rightImage_dq(:,:,i),2);
end

figure; image(uint8(rightImage_synth));
figure; image(uint8(leftImage_synth));


%Anaglyph of the synthesis
anaglyph_synth = uint8(leftImage_synth+rightImage_synth);
figure,image(anaglyph_synth), title('Synthesized Anaglyph')

%%% WIP %%%%%%
% Encode each eye's image using filters of different (usually chromatically opposite) colors, red and blue
rightImage_synth  = imtranslate(rightImage_synth,[10, 0]);

figure,image(uint8(rightImage_synth)), title('Anaglyph Synth');
r = zeros(size(rightImage_synth));
gb = zeros(size(leftImage_synth));
r(:,:,1) = double(rightImage_synth(:,:,1));
gb(:,:,2:3) = double(leftImage_synth(:,:,2:3));
anaglyph = uint8(r+gb);
figure,image(anaglyph), title('Anaglyph Synth');

% Create stereo anaglyph with Matlab function to check the result
J = stereoAnaglyph(leftImage_synth, rightImage_synth);
figure, image(uint8(J)), title('Anaglyph using Matlab function')
