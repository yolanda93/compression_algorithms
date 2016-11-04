% haar_reverse:
% Given an input haar_transform image of 256 levels, undo the transform.
function haar_matrix = haar_reverse(original_matrix)
temp_matrix = transpose(original_matrix);
temp_matrix = revert_haar(temp_matrix);
temp_matrix = transpose(temp_matrix);
haar_matrix = revert_haar(temp_matrix);
end

function haar_matrix = revert_haar(matrix)
haar_matrix = zeros(size(matrix,1),size(matrix,2));
half_col = size(matrix,2)/2;
for row = 1:size(matrix,1)
    i = 1;
    for col = 1:half_col
        haar_matrix(row,i) = matrix(row,col) - matrix(row,col + half_col);
        haar_matrix(row,i+1) = matrix(row,col) + matrix(row,col + half_col);
        i = i + 2;
    end
end
end
