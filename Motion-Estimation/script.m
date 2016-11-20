% Read the video file
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

% Transform in gray scale for simplification
reference_frame = rgb2gray(reference_frame);
new_frame = rgb2gray(new_frame);

% Plot the reference and new frames
subplot(2,2,1),subimage(reference_frame),title('Reference Frame'); hold on;
subplot(2,2,2),subimage(new_frame),title('New Frame');

% p is the search parameter, block_size is the size of the macroblock
p=7;block_size=16;

% Motion estimation using an exhaustive method
[motion_vect] = Motion_Estimation(reference_frame,new_frame,block_size,p);

% Motion competation using the motion vectors 
estimated_frame= Motion_Compensation(reference_frame, motion_vect, block_size);
subplot(2,2,3),subimage(estimated_frame),title('Estimated Frame');
draw_Optical_Flow( reference_frame, motion_vect, block_size );
hold off;

% Peak Signal-to-Noise Ratio (PSNR) to measure the distortion of the frame which is estimated and the predicted one
PSNR = image_PSNR(reference_frame, estimated_frame, 255);
fprintf('Peak-Signal-To-Noise Rario: %d \n',PSNR);


