img1 = imread('../Test-images/stereoscopy-images/image3.jpg');
figure; image(img1), title('Original Image'); % Original image

%  Split them into 2 separate images
leftImage = img1(:,1:(end/2),:);
leftImage = wextend('ar','zpd',leftImage,round(size(leftImage,1)/4)*4)
rightImage = img1(:,end/2+1:end,:);
figure; image(leftImage), title('Left Image');
figure; image(rightImage), title('Right Image');

% Encode each eye's image using filters of different (usually chromatically opposite) colors, red and blue
r = zeros(size(leftImage));
gb = zeros(size(rightImage));
r(:,:,1) = double(leftImage(:,:,1));
gb(:,:,2:3) = double(rightImage(:,:,2:3));
anaglyph = uint8(r+gb);
figure,image(anaglyph), title('My Anaglyph')

% Create stereo anaglyph with Matlab function to check the result
J = stereoAnaglyph(leftImage,rightImage);
figure, image(J), title('Anaglyph using Matlab function')

% Use TD3 to code them using 2 decomposition layers
leftImage_haar = zeros(size(leftImage,1),size(leftImage,2),size(leftImage,3));
rightImage_haar =zeros(size(rightImage,1),size(rightImage,2),size(rightImage,3));
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
    temp = leftImage(:,:,i);
    leftImage_haar(:,:,i) = haar_transform_multilevel(temp,2);

    sub11_l(:,:,i) = leftImage_haar(1:rows_l/4, 1:cols_l/4);
    sub12_l(:,:,i) = leftImage_haar(1:rows_l/4, cols_l/4+1:cols_l/2);
    sub13_l(:,:,i) = leftImage_haar(rows_l/4+1:rows_l/2, 1:cols_l/4);
    sub14_l(:,:,i) = leftImage_haar(rows_l/4+1:rows_l/2, cols_l/4+1:cols_l/2);
    sub21_l(:,:,i) = leftImage_haar(1:rows_l/2, cols_l/2+1:cols_l);
    sub22_l(:,:,i) = leftImage_haar(rows_l/2+1:rows_l, 1:cols_l/2);
    sub23_l(:,:,i) = leftImage_haar(rows_l/2+1:rows_l, 257:cols_l);
    
    rightImage_haar(:,:,i) = haar_transform_multilevel(rightImage(:,:,i),2);
    sub11_r(:,:,i) = rightImage_haar(1:rows_l/4, 1:cols_l/4);
    sub12_r(:,:,i) = rightImage_haar(1:rows_l/4, cols_l/4+1:cols_l/2);
    sub13_r(:,:,i) = rightImage_haar(rows_l/4+1:rows_l/2, 1:cols_l/4);
    sub14_r(:,:,i) = rightImage_haar(rows_l/4+1:rows_l/2, cols_l/4+1:cols_l/2);
    sub21_r(:,:,i) = rightImage_haar(1:rows_l/2, cols_l/2+1:cols_l);
    sub22_r(:,:,i) = rightImage_haar(rows_l/2+1:rows_l, 1:cols_l/2);
    sub23_r(:,:,i) = rightImage_haar(rows_l/2+1:rows_l, 257:cols_l);
end
image(leftImage_haar)


