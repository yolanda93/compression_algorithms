function haar_matrix = haar_reverse_multilevel(original_matrix, n_transforms)
    haar_matrix = original_matrix;
    for i = n_transforms-1:-1:0
        rows = 1:(size(haar_matrix,1)/2^i);
        columns = 1:(size(haar_matrix,1)/2^i);
        haar_matrix(rows,columns) = haar_reverse(haar_matrix(rows,columns));
    end
end