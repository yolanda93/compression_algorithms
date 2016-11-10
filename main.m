% figure 1
%for i = 1:8
%    temp = quantize_matrix(lena_gray_512,i);
%    subplot(2,4,i,'replace')
%    imshow(temp,[0,2^(i)-1]);
%end

%figure 2
%for i = 1:8
%    temp = quantize_matrix(lena_gray_512,i);
%    temp2 = dequantize_matrix(temp,i,8);
%    subplot(2,4,i,'replace')
%    imshow(temp2);
%end

%zeros(8,N,M)

%for j = 1:8
%    output=zeros(256,1);
%    delta = 2^(8-j);
%    for i = 0:255
%        output(i+1,1) = dequantize(quantize(i,j),delta);
%    end
%    subplot(2,4,j,'replace')
%    plot(0:255,output(:,1));
%    axis([0,255,0,255])
%end

%for j = 1:8
%    output=zeros(256,1);
%    for i = 0:255
%        output(i+1,1) = quantize(i,j);
%    end
%    subplot(2,4,j,'replace')
%    plot(0:255,output(:,1));
%    axis([0,255,0,2^(j)])
%end

%results = zeros(8,1);
%for i = 1:8
%    temp = dequantize_matrix(quantize_matrix(lena_gray_512,i),i,8);
%    D = abs(lena_gray_512-temp).^2;
%    MSE = sum(D(:))/numel(lena_gray_512);
%    results(i,1) = MSE;
%end
%plot(1:8,results);


   
%function quantization = quantize(pixel, new_bytesize)
%    dif_levels = 2^(8-new_bytesize);
%    quantization=floor(double(pixel)/double(dif_levels));
%end

%function dequantization = dequantize(pixel, delta)
    % Operation avg*Pixel+avg changed to:
%    dequantization=  delta*(double(pixel) + 0.5);
%end
