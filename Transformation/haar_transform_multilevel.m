function haar_matrix = haar_transform_multilevel(original_matrix, n_transforms)
    haar_matrix = double(original_matrix);
    for i = 1:n_transforms
        rows = 1:size(haar_matrix,1)/i;
        columns = 1:size(haar_matrix,1)/i;
        haar_matrix(rows,columns) = haar_transform(haar_matrix(rows,columns));
    end
end