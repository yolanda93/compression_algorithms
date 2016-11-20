img1 = imread('cameraman.tif');
img2 = imread('lena_gray_512.tif');
img3 = imread('mandril_gray.tif');


figure(1);
layers=5;
gaussian_layers= gaussianPyramid(img2,layers);

for k = 1:layers
subplot(1,layers,k),imshow(gaussian_layers{k});
end


layers=5;
laplacian_layers= pyramidLaplacian(img2,layers);

figure(2);
for k = 1:layers
subplot(1,layers,k),imshow(laplacian_layers{k});
end

figure(3);
%synthesis
original_img = laplacianReconstruction(laplacian_layers, layers);

imshow(original_img);