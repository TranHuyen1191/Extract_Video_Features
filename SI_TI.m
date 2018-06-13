clear;
No_fr = 900;
% H = 1920;
% W = 3840;
%vname = 'counterstrikeVR1_40s_300fr_3840x1920.yuv';
H = 544;
W = 1280;
vname = 'sintel_10fr_1280x544_30s_from0.yuv';
[Y, U, V, read_fr_id, lost_fr_count] = loadFileYuv(vname, W, H, No_fr, 1, No_fr , 0);
for i=1:No_fr
    % compute sobel filter
    h = fspecial('sobel');
    I = Y(:,:,i);
    s(:,:,i) = imfilter(I, h);
    s_1D(:,i) = reshape(s(:,:,i), 1, W * H);
    % compute standard deviation
    std_(i) = std(s_1D(:,i), 1);
    if i < No_fr 
        M(:,:,i) = Y(:,:,i+1) - Y(:,:,i);
        t_1D(:,i) = reshape(M(:,:,i), 1, W * H);
        std_ti(i) = std(t_1D(:,i), 1);
    end
end
SI = max(std_);
TI = max(std_ti);
disp(SI);
disp(TI);