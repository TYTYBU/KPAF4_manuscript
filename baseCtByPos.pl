#!/usr/bin/perl
$infile = $ARGV[0]; #fasta file
$outfile = $ARGV[1]; #base count file by posiiton
$align = $ARGV[2]; #read direction to align, l or r

if ($align eq "l"){
	print "reads are aligned to the left.\n";
}
elsif ($align eq "r"){
	print "reads are algined to the right.\n";
}
else {
	print "need to know counting direction (l/r).\n";
	exit;
}

open IN, "<", $infile or die;
open OUT, ">", $outfile or die;

print OUT "pos\tA\tT\tG\tC\n";
while (my $id = <IN>){
	chomp $id;
	my $ct = 1;
	if ($id =~ /_x(.*)/){
		$ct = $1;
	}
	my $seq = <IN>;
	chomp $seq;
	if ($align eq "r"){
		$seq = reverse $seq;
	}

	my $pos = 1;
	foreach my $n (split //, $seq){
		unless (exists $hash{$pos}){
			$hash{$pos}{"A"} = 0;
			$hash{$pos}{"T"} = 0;
			$hash{$pos}{"G"} = 0;
			$hash{$pos}{"C"} = 0;
		}
		$hash{$pos}{$n} += $ct;
		$pos++;
	}
}

foreach my $pos (sort {$a <=> $b} keys %hash){
	print OUT $pos . "\t" . $hash{$pos}{"A"} . "\t" . $hash{$pos}{"T"} . "\t" . $hash{$pos}{"G"} . "\t" . $hash{$pos}{"C"} . "\n";
}
