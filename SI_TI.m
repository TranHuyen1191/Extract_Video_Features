clear
clc
close all
%%%%%%%%%%%%%%%% PARAMETERS OF VIDEOS %%%%%%%%%%%%%%%
No_frame = 100;
yuvname = sprintf('Cook.yuv');
Height = 1920;
Width = 3840;

%%%%%%%%%%%%%%%% Source code %%%%%%%%%%%%%%%
[Y, U, V, read_fr_id, lost_fr_count] = loadFileYuv(yuvname, Width, Height, No_frame, 1, No_frame , 0);
for i=1:No_frame
    % compute sobel filter
    h = fspecial('sobel');
    I = Y(:,:,i);
    s(:,:,i) = imfilter(I, h);
    s_1D(:,i) = reshape(s(:,:,i), 1, Width * Height);
    % compute standard deviation
    std_(i) = std(s_1D(:,i), 1);
    if i < No_frame 
        M(:,:,i) = Y(:,:,i+1) - Y(:,:,i);
        t_1D(:,i) = reshape(M(:,:,i), 1, Width * Height);
        std_ti(i) = std(t_1D(:,i), 1);
    end
end
SI = max(std_);
TI = max(std_ti);
disp(SI);
disp(TI);