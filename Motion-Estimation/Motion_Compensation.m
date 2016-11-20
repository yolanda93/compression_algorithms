function  estimated_image = Motion_Compensation( reference_frame, motion_vect, block_size)
%Motion_Compensation algorithm. Predicts the next image using the motion
%vectors
%   
%  Input 
%   reference_frame  : The frame{t-1} 
%   motion_vect      : The motion vectors for each macroblock 
%   block_size       : Size of the macroblock
%
%  Output
%   estimated_image  : Result of using the motion vectors to predict a frame in a video stream
%

[row, col] = size(reference_frame);
vect_count = 1;
image_compensation = reference_frame;

for i = 1:block_size:row-block_size
    for j = 1:block_size:col-block_size        
        dy = motion_vect(1,vect_count);
        dx = motion_vect(2,vect_count);
        y_block = i + dy;
        x_block = j + dx;
        if(y_block>=1&&x_block>=1&&dy~=0&&dx~=0)      
            image_compensation(i:i+block_size-1,j:j+block_size-1) = reference_frame(y_block:y_block+block_size-1, x_block:x_block+block_size-1);
        end
        vect_count = vect_count + 1;
    end
end

estimated_image = image_compensation;

end

