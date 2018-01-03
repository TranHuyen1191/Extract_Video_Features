my @Video_arr 	= ("BBB","ST");
my @QP_arr 		= (24,26,28,32,36,40,48,52);
my $No_video 	= 2;
my $No_ver 		= 8;
my $T_e			= 120;
my $R_file = "VQM.txt";
open RESULT_FILE, ">$R_file"; 
printf RESULT_FILE "Video\tQP\tResolution\tAverageVQM\n";


for (my $cnt_v = 0; $cnt_v < $No_video; $cnt_v++) {
	my $Name = $Video_arr[$cnt_v];
	for (my $cnt_qp = 0; $cnt_qp < $No_ver; $cnt_qp++) {
		my $QP = $QP_arr[$cnt_qp];
		my $cmd = "./vqtool -r ${Name}/${Name}_Res720.mp4 -R mp4 -p ${Name}/${Name}_qp${QP}_Res720_vbr.mp4 -P mp4 -t $T_e  --vqm  ${Name}_QP${QP}_Res720";
		#print "$cmd \n";
		system $cmd;


		# Extract the average of VQM
		my $VQM_file 	= "${Name}_QP${QP}_Res720_vqm_${T_e}s.csv";
		my $No_Fr 		= 0;
		my $sum 		= 0;
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
		printf RESULT_FILE "${Name}\t${QP}\t720\t$AVQM\n";
	}
}