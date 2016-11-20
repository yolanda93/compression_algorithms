function paddedMatrix = paddingZeros(matrix, divisor)
    %paddedMatrix = zeros(size(matrix,1), size(matrix,2), size(matrix,3));
    rows = size(matrix,1);
    cols = size(matrix,2);
    paddedMatrix = wextend('ar','sym',matrix, round(rows/divisor)*divisor - rows, 'd');
    paddedMatrix = wextend('ac','sym',paddedMatrix, round(cols/divisor)*divisor - cols, 'l');
end