img1 = imread('../Test-images/stereoscopy-images/image3.jpg');
figure; image(img1), title('Original Image'); % Original image

%  Split them into 2 separate images
leftImage = img1(:,1:end/2,:);
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
img_lena = imread('../Test-images/lena_gray_512.tif');

%leftImage_haar = haar_transform_multilevel(leftImage,2);
%rightImage_haar = haar_transform_multilevel(rightImage,2);
