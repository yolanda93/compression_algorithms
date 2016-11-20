function draw_Optical_Flow( reference_frame, motion_vect, block_size )
%UNTITLED Draw the motion vectors in the reference frame

[row, col] = size(reference_frame);
mbCount = 1;
subplot(2,2,4),subimage(reference_frame),title('Motion Vectors');
hold on;
for i = 1:block_size:row-block_size
    for j = 1:block_size:col-block_size       
        dy = motion_vect(1,mbCount);
        dx = motion_vect(2,mbCount);
        y_block = i + dy;
        x_block = j + dx;
        if((y_block>=1&&x_block>=1&&dy~=0&&dx~=0) &&  (motion_vect(3,mbCount)>0.4) && (x_block<=size(reference_frame,1)) && (y_block<=size(reference_frame,2)))
            quiver(j,i,dx, dy,'color', 'b', 'linewidth', 1);
        end
        mbCount = mbCount + 1;
    end
end
hold off;

end

