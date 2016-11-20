function [ x_predicted, y_predicted, min_MSE ] = Block_Matching( reference_frame, new_frame, p, x, y, block_size  )
% Block_Matching Algorithm. Block Matching between 2 subsequent frames to detect motion estimation
%
% Input
%   reference_frame :  The frame{t-1}
%   new_frame       :  The frame{t}
%   p               :  Search parameter
%   x,y             :  Position withing the frame
%   block_size      :  Size of the macroblock
% 
% Ouput 
%   motion_vect     :  Motion vector for each macroblock
%   min_MSE         :  The minimum MSE (Mean Square Error)
% 

reference_block = reference_frame(x:x+(block_size-1),y:y+(block_size-1));
MSE = ones(2*p + 1, 2*p +1) * 65537;

% Search the correspondence of the macroblock of a reference frame
% using an exhaustive method. This method searches for the minimum
% cost function at each possible location with respect to the search parameter.

for m=-p:p
    for n=-p:p
        new_xpos = x + m;
        new_ypos = y + n;
        if(new_xpos+block_size>size(reference_frame,1) || new_ypos+block_size>size(reference_frame,2) || new_xpos<1 || new_ypos<1)
            continue;
        else
            new_block =new_frame(new_xpos:new_xpos+(block_size-1),new_ypos:new_ypos+(block_size-1));
            MSE(m+p+1,n+p+1)=double(mean2(((reference_block-new_block).^2)));
        end
    end
end

% Create the motion vectors with the minimum cost function.
min = 70000;
for i = 1:size(MSE,1)
    for j = 1:size(MSE,2)
        if (MSE(i,j) < min)
            min = MSE(i,j);
            dx = j; dy = i;
        end
    end
end

min_MSE = min;
x_predicted = dx;
y_predicted = dy;

end

