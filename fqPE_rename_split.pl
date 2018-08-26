#!/usr/bin/perl
$infile=$ARGV[0]; #read1.fa
$infile2=$ARGV[1]; #read2.fa
$outfile=$ARGV[2];
$outfile2=$ARGV[3];
$prefix=$ARGV[4];
$ctPerFile = $ARGV[5];

open IN, "<", $infile or die;
open IN2, "<", $infile2 or die;

$idError_ct=0;
$N_ct=0;
$total_ct = 0;
$pass_ct = 0;
$data1="";
$data2="";
$pt = 1;

while ($id1=<IN>){
	$total_ct++;
	
	$seq1=<IN>;
	<IN>;
	$qual1=<IN>;
	$id2=<IN2>;
	$seq2=<IN2>;
	<IN2>;
	$qual2=<IN2>;
	
	if ($id1 =~ /([^ ]+)/){
		$id1=$1;
	}
	
	if ($id2 =~ /([^ ]+)/){
		$id2=$1;
	}
	
	if ($id1 eq $id2){
		if ($seq1 =~ /N/){
			$N_ct++;
			next;
		}
		
		if ($seq2 =~ /N/){
			$N_ct++;
			next;
		}
		
		$pass_ct++;
		$id = "@" . $prefix . "_" . $pass_ct;
		$data1 .= $id . " 1\n" . $seq1 . "+\n" . $qual1;
		$data2 .= $id . " 2\n" . $seq2 . "+\n" . $qual2;
	}
	else {
		$idError_ct++;
	}
	
	if ($pass_ct % $ctPerFile == 0){
		open OUT1, ">", $outfile . ".pt" . $pt or die;
		open OUT2, ">", $outfile2 . ".pt" . $pt or die;
		print OUT1 $data1;
		print OUT2 $data2;
		close OUT1;
		close OUT2;
		
		$data1 = "";
		$data2 = "";
		$pt++;
	}
}

open OUT1, ">", $outfile . ".pt" . $pt or die;
open OUT2, ">", $outfile2 . ".pt" . $pt or die;
print OUT1 $data1;
print OUT2 $data2;
close OUT1;
close OUT2;

print "total_ct: " . $total_ct . "\n";
print "pass_ct: " . $pass_ct . "\n";
print "idError_ct: " . $idError_ct . "\n";
print "N_ct: " . $N_ct . "\n";
print "pt: " . $pt . "\n";



