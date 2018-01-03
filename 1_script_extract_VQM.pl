my @Video_arr = ("BBB","ST");
my @QP_arr = (24,26,28,32,36,40,48,52);
my $No_video = 2;
my $No_ver = 8;

for (my $cnt_v = 0; $cnt_v < $No_video; $cnt_v++) {
	my $Name = $Video_arr[$cnt_v];
	for (my $cnt_qp = 0; $cnt_qp < $No_ver; $cnt_qp++) {
		my $QP = $QP_arr[$cnt_qp];
		my $cmd = "./vqtool -r ${Name}/${Name}_Res720.mp4 -R mp4 -p ${Name}/${Name}_qp${QP}_Res720_vbr.mp4 -P mp4 -t 120  --vqm  ${Name}_QP${QP}_Res720";
		print "$cmd \n";
		system $cmd;
	}
}