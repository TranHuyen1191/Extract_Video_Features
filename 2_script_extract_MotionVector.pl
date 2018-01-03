sub average2D { 
	my @array = @_; 
	my $sum = 0;
	my $counter = 0;
	foreach my $E1(@_) {  
  		foreach my $E2 (@$E1)  { 
  			# printf "# $E2 $counter";
  			$sum += $E2;
  			$counter ++;
  		}	
  	}
  	# printf "############# $sum $counter\n";
	return $sum/$counter;
} 

sub average1D { 
	my @array = @_; 
	my $sum = 0;
	my $counter = 0;
	foreach my $E1(@_) {  
  		if  ($E1 != 0){
	  		#printf "# $E1 $counter \n";
  		}
  		$sum += $E1; 
  		$counter ++;
  	}
  	#printf "############# $sum $counter\n";
	return $sum/$counter;
} 
@foo = (
         [1, 3,5],
         [2, 4,5],
       );
#printf(average2D(@foo));

@foo = (1,2,3);
#printf(average1D(@foo));

my $W_Video   = 1280;
my $H_Video   = 720;
my $Nw_MB     = $W_Video / 16; # Number of macroblock in the horizontal direction
my $Ny_MB     = $H_Video / 16; # Number of macroblock in the vertical direction
my $No_Frames = 300;
my @Video_arr = ("BBB","ST","News","Sport");
my $No_video  = 4;
my $R_file    = "AverageMVA.txt";
open RESULT_FILE, ">$R_file"; 
printf RESULT_FILE "Video\tAverageMVA\n";

for (my $cnt_v = 0; $cnt_v < $No_video; $cnt_v++) {
	my $Name = $Video_arr[$cnt_v];
	my $cmd = "ffmpeg -y -i ${Name}/${Name}_Res720.mp4 -frames $No_Frames ${Name}/${Name}_Res720.mp4_${No_Frames}fr.mp4";
	system $cmd;

	my 	$MV_file 	= "${Name}_QP${QP}_Res720_MotionVectors.txt";
	my $cmd = "./extract_mvs ${Name}/${Name}_Res720.mp4_${No_Frames}fr.mp4 > $MV_file";
	system $cmd;

	my $F_id = 0; # Frame's index
	my $srcx = 0; 
	my $srcy = 0; 
	my $dstx = 0; 
	my $dsty = 0;
	my @MVA  = 0; # Motion vector amplitude
	my $MB_id = 0; # Macroblock index
	open MV_F,"$MV_file";
	while (<MV_F>){
		chomp;
		my $line = $_;
		if(($line =~ /\s*\d+,-\d+,\s*\d+,\s*\d+,\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)/) || ($line =~ /\s*\d+,\s*\d+,\s*\d+,\s*\d+,\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)/)){
			$srcx = $1; 
			$srcy = $2; 
			$dstx = $3; 
			$dsty = $4;
			$MVA[$MB_id]  = sqrt((($dstx - $srcx)/${Nw_MB})**2 + (($dsty - $srcy)/${Ny_MB})**2);
			#$MVA[$MB_id]  = sqrt((($dstx - $srcx))**2 + (($dsty - $srcy))**2);
			#printf "$1 $2 $3 $4 $MVA[$MB_id] $MB_id \n";
			$MB_id ++;
		}
		else{
			#printf("##### $line \n");
		}
	}
	close ENC;
	my $AMVA = average1D(@MVA);
	printf RESULT_FILE "${Name}\t$AMVA\t$MB_id\n";
}