function PSNR = image_PSNR(reference_image, estimated_image)

[row, col] = size(reference_image);
sum_err = 0;
for i = 1:row
    for j = 1:col
        sum_err = sum_err + (reference_image(i,j) - estimated_image(i,j))^2;
    end
end
mse = sum_err/(row*col);
PSNR = 10*log10(double(255^2/mse));