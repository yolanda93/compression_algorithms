% dequantize_matrix:
% Uniformly projects a matrix with a number of levels (2^old_bytesize)
% into a new matrix with a number of levels (2^new_bytesize)
function dequantized_matrix = dequantize_matrix(matrix, old_bytesize, new_bytesize)
avg_point = 2^(new_bytesize-old_bytesize-1);
dequantized_matrix = zeros(size(matrix,1),size(matrix,2),'uint8');
for row = 1:size(matrix,1)
    for col = 1:size(matrix,2)
        dequantized_matrix(row,col) = dequantize(matrix(row,col), avg_point);
    end
end

function dequantization = dequantize(pixel, avg_point)
dequantization= avg_point*(pixel + 1);
end
