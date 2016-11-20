function [ laplacian_layers ] = pyramidLaplacian( input_img, N )
%pyramideLaplacian laplacian pyramid
% N decomposition layers

laplacian_layers=cell(1,N);
% Convolve the filtered image with the gaussian filter
decomposition_layers = gaussianPyramid( input_img, N );

for k = 1:N-1
 
img_upsampled = upsampling(decomposition_layers{k+1});
img_upsampled = upsampling(img_upsampled')';

% Construct N Laplacian descomposition layer
laplacian_layers{k}= uint8(decomposition_layers{k}) - uint8(img_upsampled);
end
laplacian_layers{N} = imgaussfilt3(decomposition_layers{N-1}, 3);

end

function [ output_img ] = upsampling( input_img )
%gaussianPyramid Build the gaussianPyramid

output_img =  zeros(size(input_img,1)*2,size(input_img,2));

j=1;
for k = 1:1:size(input_img,1)
output_img(j,:) = input_img(k,:);
output_img(j+1,:) = input_img(k,:);
j=j+2;
end

end

function [ output_img ] = gaussianFilter( input_img, sigma )
%gaussianFilter Build a 2D Gaussian Filter
if nargin==1, sigma=0.5; end 
x = -5:5; % sigma = 1, support = ?2:2 (N=5)
h = exp(-(x.^2)/(2*sigma.^2)); % Gauss expression 1D
h = h/sum(h); % Normalize; sum=1
G = h' * h; % 2D mask

output_img = imfilter(input_img,G,'same'); % convolve image 

end

