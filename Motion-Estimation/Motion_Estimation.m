function motion_vectors = Motion_Estimation(reference_frame, new_frame, block_size, p)
%Motion_Estimation algorithm  Computes motion vectors using exhaustive search method
%
% Input
%   reference_frame : The frame{t-1} 
%   new_frame       : The frame{t}
%   p               : Search parameter
%   block_size      : Size of the macroblock
%
% Ouput
%   motion_vectors  : The motion vectors for each macroblock 
%

[rows, cols] = size(reference_frame);
motion_vectors = zeros(3,rows*cols/block_size^2);

vect_count = 1;
for posx = 1:block_size:rows-block_size
    for posy = 1:block_size:cols-block_size
          [predicted_posx,predicted_posy,min_MSE]=Block_Matching( reference_frame, new_frame, p, posx, posy, block_size  );
          motion_vectors(1:2,vect_count) = [predicted_posx,predicted_posy];
          motion_vectors(3,vect_count) = min_MSE;
          vect_count = vect_count+1;
    end
end

end

