function [ original_img ] = laplacianReconstruction( laplacian_layers, layers )
%laplacianReconstruction 
layers
img_upsampled =laplacian_layers{layers}
for k = layers-1:-1:1
k
original_img = uint8(laplacian_layers{k}) + uint8(img_upsampled);
img_upsampled = upsampling(original_img);
img_upsampled = upsampling(img_upsampled')';
end
%original_img = original_img
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