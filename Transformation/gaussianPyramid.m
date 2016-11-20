
function [ decomposition_layers ] = gaussianPyramid( input_img, N )
%gaussianPyramid Build the gaussianPyramid
decomposition_layers=cell(1,N);
decomposition_layers{1}=input_img; % first layer is the original image

for k = 1:N-1
gauss_img = imgaussfilt3(decomposition_layers{k}, 3); 
aux = downsample(gauss_img,2);
decomposition_layers{k+1}= downsample(aux',2)';
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
