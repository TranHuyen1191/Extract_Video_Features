my @Video_arr = ("Sport","New2");
my @QP_arr = (24,26);
my @Res_arr= (144,240,360,480,720);
my $No_video = 2;
my $No_qp = 2;
my $No_res = 5;

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
				my $cmd =  "./vqtool -r ${Name}/${Name}_Res720.mp4 -R mp4 -p ${Name}/${Name}_qp${QP}_Res${Res}_vbr_Res720.mp4 -P mp4 -t 120  --vqm  ${Name}_QP${QP}_Res${Res}";
				print "$cmd \n";
				system $cmd;
			}
			else {
				my $cmd =  "./vqtool -r ${Name}/${Name}_Res720.mp4 -R mp4 -p ${Name}/${Name}_qp${QP}_Res${Res}_vbr.mp4 -P mp4 -t 120  --vqm  ${Name}_QP${QP}_Res${Res}";
				print "$cmd \n";
				system $cmd;
			}
		}
	}
}