% haar_transform:
% Given an input greyscale image of 256 levels, apply the haar transform to it.
% Will apply the transform first to the rows and then to the columns
function haar_matrix = haar_transform(original_matrix)
temp_matrix = haar_pass(original_matrix);
temp_matrix = transpose(temp_matrix);
temp_matrix = haar_pass(temp_matrix);
haar_matrix = transpose(temp_matrix);
end

function haar_matrix = haar_pass(matrix)
haar_matrix = zeros(size(matrix,1),size(matrix,2));
half_col = size(matrix,2)/2;
for row = 1:size(matrix,1)
    i = 1;
    for col = 1:2:size(matrix,2)
        haar_matrix(row,i) = (matrix(row,col)+matrix(row,col+1))/2;
        haar_matrix(row,i+half_col) = matrix(row,col) - matrix(row,col+1);
        i = i + 1;
    end
end
end
