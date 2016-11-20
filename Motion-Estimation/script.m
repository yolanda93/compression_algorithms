video=VideoReader('../Test-images/Xylophone.mp4');
n=video.NumberofFrames;

% Divide the video in frames
for x=1:n
frame=read(video,x);
imwrite(frame,sprintf('../Test-images/Frames/image%d.jpg',x));
end

% Compute the motion vectors between 2 frames
reference_frame = imread('../Test-images/Frames/image40.jpg');
new_frame = imread('../Test-images/Frames/image41.jpg');

figure;imshow(reference_frame),title('Reference Frame');imshow(new_frame),title('New Frame');

tic
% Motion Estimation
p=3;block_size=16;
predicted_pos = zeros(round(size(reference_frame,1)/block_size),round(size(reference_frame,2)/block_size),2);
i=1;j=1;
%Display the optical flow
figure;imshow(reference_frame),title('Motion Vectors');
hold on;
for posx = 1:block_size:size(reference_frame,1)-block_size
    for posy = 1:block_size:size(reference_frame,2)-block_size
          [predicted_posx,predicted_posy,min_MSE]=Block_Matching( reference_frame, new_frame, p, posx, posy, block_size  );
          if(min_MSE>=0.4)
            fprintf('Movement detected, draw motion vectors')
            quiver(posx, posy, predicted_posx,predicted_posy,'color', 'b', 'linewidth', 1);
          end     
    end
end
toc

% Predict the next frame between 2 frames taken randomly
reference_frame = imread('../Test-images/Frames/image1.jpg');

tic
% Predict image
p=3;block_size=16;N=2;
MSE_frames = zeros(1,N);
for i = 1:1:N
    min_MSE=0;
    path = sprintf('../Test-images/Frames/image%d.jpg',i);
    new_frame = imread(path);
    for posx = 1:size(reference_frame,1)
        for posy = 1:size(reference_frame,2)
            if(posx+block_size<size(reference_frame,1) && posy+block_size<size(reference_frame,2))
               [~,~,MSE]= Block_Matching( reference_frame, new_frame, p, posx, posy, block_size  );
              min_MSE= min_MSE + MSE; % Compute the sum between all macroblocks 
            end
        end
    end
    fprintf('Mean Square Error: %d \n',min_MSE);
    MSE_frames(i) = min_MSE;
end
toc
pred_frame = find(min(MSE_frames(i)));
fprintf('The predicted frame is: %d \n',pred_frame);

PSNR=10*(log(255^2/MSE_frames(pred_frame))/log(10));
fprintf('Peak-Signal-To-Noise Rario of the predicted frame: %d \n',PSNR);
