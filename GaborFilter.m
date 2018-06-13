%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Note that this function uses the function of "gaborconvolve" which can be found in the link: %%%%%%%%
%%%%%%%%% https://github.com/carandraug/PeterKovesiImage/blob/master/PhaseCongruency/gaborconvolve.m %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all
%%% Extract Gm_f (Gabor feature), Muy_FD, STD (sigma), and NFD %%%
%%%%%%%%%%%%%%%% PARAMETERS OF VIDEOS %%%%%%%%%%%%%%%
No_frame = 5;
yuvname = sprintf('Cook.yuv');
Height = 1920;
Width = 3840;
[Y, U, V, read_fr_id, lost_fr_count] = loadFileYuv(yuvname, Width, Height,No_frame, 1, No_frame , 0);
Gm_ = zeros(1,No_frame);
FD  = zeros(1,No_frame-1);
STD = zeros(1,No_frame);

%%%%%%%%%%%%%%% FUNCTION %%%%%%%%%%%%%%
for n = 1:No_frame 
    [EO, BP] = gaborconvolve(Y(:,:,n), 2, 2, 3, 1.7, 0.65, 1.3, 0, 0);
    Gm=zeros(1,4); 
    for i = 1:2 
        for j = 1:2 
            A= abs(EO{i,j});
            B=int16(A);
            %imshow(B,[]);
            Gm((i-1)*2+j)= mean(reshape(B,1,[]));
        end
    end
    Gm_(n) = mean(Gm);
    if n<No_frame
        C = reshape(Y(:,:,n),1,[]) -reshape(Y(:,:,n+1),1,[]);
        FD(n) = mean(abs(C));
    end
    STD(n)=std(reshape(Y(:,:,n),1,[]));
end
Gm_f= mean(reshape(Gm_,1,[]));
NFD=mean(Muy_FD)/mean(STD);
