my @Video_arr 	= ("Sport","News");
my @QP_arr 		= (24,26);
my @Res_arr		= (144,240,360,480,720);
my $No_video 	= 2;
my $No_qp 		= 2;
my $No_res 		= 5;
my $T_e			= 2;
my $R_file = "VQM_Res.txt";
open RESULT_FILE, ">$R_file"; 
printf RESULT_FILE "Video\tQP\tResolution\tAverageVQM\n";

for (my $cnt_v = 0; $cnt_v < $No_video; $cnt_v++) {
	my $Name = $Video_arr[$cnt_v];
	for (my $cnt_qp = 0; $cnt_qp < $No_qp; $cnt_qp++) {
		my $QP = $QP_arr[$cnt_qp];
		for (my $cnt_res = 0; $cnt_res < $No_res; $cnt_res++) {
			my $Res = $Res_arr[$cnt_res];
			if ($cnt_res != 4) {
				my $cmd = 	"ffmpeg -y -i ${Name}/${Name}_qp${QP}_Res${Res}_vbr.mp4 -s 1280x720 -qp 0 -frames 3600 ${Name}/${Name}_qp${QP}_Res${Res}_vbr_Res720.mp4";
				print "$cmd \n";
				system $cmd;
				my $cmd =  "./vqtool -r ${Name}/${Name}_Res720.mp4 -R mp4 -p ${Name}/${Name}_qp${QP}_Res${Res}_vbr_Res720.mp4 -P mp4 -t $T_e  --vqm  ${Name}_QP${QP}_Res${Res}";
				print "$cmd \n";
				system $cmd;
			}
			else {
				my $cmd =  "./vqtool -r ${Name}/${Name}_Res720.mp4 -R mp4 -p ${Name}/${Name}_qp${QP}_Res${Res}_vbr.mp4 -P mp4 -t $T_e  --vqm  ${Name}_QP${QP}_Res${Res}";
				print "$cmd \n";
				system $cmd;
			}



			# Extract the average of VQM
			my $VQM_file 	= "${Name}_QP${QP}_Res${Res}_vqm_${T_e}s.csv";
			my $No_Fr 		= 0;
			my $sum 		= 0;
			#printf $VQM_file;
			open VQM_F,"$VQM_file";
			while (<VQM_F>){
				chomp;
				my $line = $_;
				#printf $line;
				if($line =~ /\d+;(\d+.\d+)/){
					$No_Fr ++;
					$sum = $sum + $1;
				}
			}
			my $AVQM = $sum/$No_Fr;
			printf RESULT_FILE "${Name}\t${QP}\t${Res}\t$AVQM\n";
		}
	}
}