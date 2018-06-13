clear
clc
close all
%%%%%%%%%%%%%%%% PARAMETERS OF VIDEOS %%%%%%%%%%%%%%%
No_frame = 900;
No_frame_sub = 100; % Phai chia thanh cac subgroup de tinh toan, vi matlab han che memory (RAM).
yuvname = sprintf('Cook.yuv');
Height = 1920;
Width = 3840;

%%%%%%%%%%%%%%%% FUNCTION %%%%%%%%%%%%%%%
blockh = 17;
blockw = 17;
for index = 1:1:(No_frame/No_frame_sub)
    fname = sprintf('Motion%d.txt',index);
    fname2 = sprintf('Motion_FrameBasis%d.txt',index);
    fout = fopen(fname,'w');
    fprintf(fout,'No_fr\tBlockw\tBlockh\tMVw\tMVh\tDeltaPixel\n');
    fout2 = fopen(fname2,'w');
    fprintf(fout2,'No_fr\tMeanDeltaPixel\tSTDDeltaPixel\n'); 
    if index == 1
        No_frame_cal = No_frame_sub;
        start = 1;
    else
        No_frame_cal = No_frame_sub+1;
        start = (index-1)*No_frame_sub; % tinh ca cai cuoi cung cua sub phia truoc
    end
    [Y_sr, U_sr, V_sr, read_fr_id, lost_fr_count] = loadFileYuv(yuvname, Width, Height,No_frame, start, No_frame_cal, 0);
    for index_sub = 1: No_frame_cal-1
        img1 = Y_sr(:,:,index_sub);
        img2 = Y_sr(:,:,index_sub+1);
        hbm = vision.BlockMatcher('ReferenceFrameSource',...
                'Input port','BlockSize',[blockh blockw]);
        hbm.OutputValue = 'Horizontal and vertical components in complex form';
        halphablend = vision.AlphaBlender;
        motion = step(hbm,img1,img2);
        img12 = step(halphablend,img2,img1);
        [W_arr, H_arr] = meshgrid(1:blockw:size(img1,2),1:blockh:size(img1,1));
        imshow(img12./255);
        hold on;
        quiver(W_arr(:),H_arr(:),real(motion(:)),imag(motion(:)),0);
        hold off;
        for h = 1: size(motion,1)
            for w = 1:size(motion,2)
                if index == 1
                    Fr_n = (index-1)*No_frame_sub+index_sub;
                else
                    Fr_n = (index-1)*No_frame_sub+index_sub-1;
                end
                if H_arr(h,w)+imag(motion(h,w)) <=0
                    dst_h = 1;
                else
                    dst_h = H_arr(h,w)+imag(motion(h,w));
                end
                if W_arr(h,w)+real(motion(h,w)) <=0
                    dst_w = 1;
                else
                    dst_w = W_arr(h,w)+real(motion(h,w));
                end   
                Delta_img(h,w,index_sub) = img1(H_arr(h,w),W_arr(h,w)) - img2(dst_h,dst_w); 
                fprintf(fout,'%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.2f\n',Fr_n,W_arr(h,w),...
                    H_arr(h,w),real(motion(h,w)),imag(motion(h,w)),Delta_img(h,w,index_sub));
            end
        end
        fprintf(fout2,'%.0f\t%.6f\t%.6f\n',Fr_n,mean(reshape(Delta_img(:,:,index_sub),[],1)),...
            std(reshape(Delta_img(:,:,index_sub),[],1),1));
    end
end