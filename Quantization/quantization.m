function [ out_image ] = quantization( input_image,layers )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
gray_scale=255;
slide_size=gray_scale/layers; 

out_image=zeros(size(input_image));

for i =  1:size(input_image,1)
   for j = 1:size(input_image,2)
     aux=0;
       while(aux<input_image(i,j))
         aux = aux + slide_size;
       end
         out_image(i,j)=round(aux-slide_size/2);
   end
end


end

