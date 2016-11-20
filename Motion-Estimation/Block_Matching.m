function [ x_predicted, y_predicted, min_MSE ] = Block_Matching( reference_frame, new_frame, p, x, y, block_size  )
%Block_Matching Algorithm. Block Matching between 2 subsequent frames to detect motion estimation
%   reference_frame   The frame{t-1}
%   new_frame         The frame{t}
%   p                 Search parameter
%   x,y               Position withing the frame
%   block_size        Size of the macroblock

reference_block = reference_frame(x:x+block_size,y:y+block_size,:);
MSE = zeros(p,p);

for new_xpos=x-p:1:x+(p-1)
    for new_ypos=y-p:1:y+(p-1)
        if(new_xpos+block_size>size(reference_frame,1) || new_ypos+block_size>size(reference_frame,2) || new_xpos<=0 || new_ypos<=0)
          MSE(new_xpos-(x-p)+1,new_ypos-(y-p)+1)=1000;
        else
          new_block =new_frame(new_xpos:new_xpos+block_size,new_ypos:new_ypos+block_size,:);
          MSE(new_xpos-(x-p)+1,new_ypos-(y-p)+1)=double(mean2(((reference_block-new_block).^2)));
        end
    end
end

min_MSE = min(min(MSE));

[min_x,min_y]=find(min_MSE);

if(isempty(min_x)&&isempty(min_y)) % no movement detected
 x_predicted = x;
 y_predicted = y;
else
  x_predicted = min_x+(x-p);
 y_predicted = min_y+(y-p);
end    

end

