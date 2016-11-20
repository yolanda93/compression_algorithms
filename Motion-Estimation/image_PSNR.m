function PSNR = image_PSNR(new_image, estimated_image)

[row, col] = size(new_image);
sum_err = 0;
for i = 1:row
    for j = 1:col
        sum_err = sum_err + double(mean2(abs(double(new_image(i,j)) - double(estimated_image(i,j))).^2));
    end
end

PSNR = 10*log10(double(255^2/sum_err));