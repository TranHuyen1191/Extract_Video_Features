NoVideo = 3;
NameVArr = {'BBB','ST','ToS'};
NoMetric = 10;
NameMArr = {'vifp','ssim','psnr','msssim','psnrhvsm','psnrhvs','bitrate','ehd','mvAver','mvSTD'};

for v = 1:NoVideo
    filenameversess = sprintf('%s_Ver.csv',string(NameVArr(v)));
    VerSess = importfilever(filenameversess, 1, inf);
    for m = 1:NoMetric
        filenamemetric = sprintf('%s_result_%s.csv',string(NameVArr(v)),string(NameMArr(m)));
        [Seg,Metric] = importfilemetric(filenamemetric, 2, inf);
        NoSess = size(VerSess,1);
        NoSeg  = size(VerSess,2);
        for ss = 1:NoSess
            MetricSess(ss,1) = ss;
            for sg = 1:NoSeg
               if sg > size(Metric,2) % metric array does not enough information for all segments
                    MetricSess(ss,sg+1) = Metric(VerSess(ss,sg),size(Metric,2));
               else
                    MetricSess(ss,sg+1) = Metric(VerSess(ss,sg),sg);
               end
            end
        end
        filename = sprintf('%s_%s.csv',string(NameVArr(v)),string(NameMArr(m)));
        csvwrite(filename,MetricSess);
    end
end


for v = 1:NoVideo
    filenameversess = sprintf('%s_Ver.csv',string(NameVArr(v)));
    VerSess = importfilever(filenameversess, 1, inf);
    for m = 8:NoMetric
        filenamemetric = sprintf('%s_result_%s.csv',string(NameVArr(v)),string(NameMArr(m)));
        [Seg,Metric] = importfilemetric(filenamemetric, 2, inf);
        NoSess = size(VerSess,1);
        NoSeg  = size(VerSess,2);
        for ss = 1:NoSess
            MetricSess(ss,1) = ss;
            for sg = 1:NoSeg
               if sg > size(Metric,2) % metric array does not enough information for all segments
                    MetricSess(ss,sg+1) = Metric(size(Metric,1),size(Metric,2)); % version with qp =0
               else
                    MetricSess(ss,sg+1) = Metric(size(Metric,1),sg);% version with qp =0
               end
            end
        end
        filename = sprintf('%s_%sori.csv',string(NameVArr(v)),string(NameMArr(m)));
        csvwrite(filename,MetricSess);
    end
end
