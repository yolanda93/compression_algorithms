function quantized_matrix = quantize_matrix(matrix, new_bytesize)
    quantized_matrix = zeros(size(matrix,1),size(matrix,2),'uint8');
    for row = 1:size(matrix,1)
        for col = 1:size(matrix,2)
            quantized_matrix(row,col) = quantize(matrix(row,col), new_bytesize);
        end
    end
end

function quantization = quantize(pixel, new_bytesize)
    dif_levels = 2^(8-new_bytesize);
    quantization=floor(double(pixel)/dif_levels);
end