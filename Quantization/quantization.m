function [ out_image ] = quantization( input_image,levels,scale )
%quantization Uniform scalar quantization
if nargin==2, scale=256; end 
cluster_size=scale/levels; 

out_image=zeros(size(input_image));

for i =  1:size(input_image,1)
   for j = 1:size(input_image,2)
         out_image(i,j) = (((round(input_image(i,j))/cluster_size)-cluster_size)/2);
   end
end

out_image = uint8(out_image);
end
