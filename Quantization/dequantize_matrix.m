% dequantize_matrix:
% Uniformly proyects a matrix with a number of levels (2^old_bytesize)
% into a new matrix with a number of levels (2^new_bytesize)
%  
% Correct behaviour only when: 
%   new_bytesize >= old_bytesize
function dequantized_matrix = dequantize_matrix(matrix, old_bytesize, new_bytesize)
    delta = 2^(new_bytesize-old_bytesize);
    dequantized_matrix = zeros(size(matrix,1),size(matrix,2),'uint8');
    for row = 1:size(matrix,1)
        for col = 1:size(matrix,2)
            dequantized_matrix(row,col) = dequantize(matrix(row,col), delta);
        end
    end
end

function dequantization = dequantize(pixel, delta)
    % Operation avg*Pixel+avg changed to:
    dequantization = delta*(double(pixel) + 0.5);
end