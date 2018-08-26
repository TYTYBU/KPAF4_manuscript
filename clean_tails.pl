#!/usr/bin/perl

$infile = $ARGV[0]; #input.fa
$outfile = $ARGV[1]; #output tails.fa without weird content
$error_rate = $ARGV[2]; #error rate

open IN, "<", $infile or die;
open OUT, ">", $outfile or die;

while (my $id = <IN>){
	my $seq = <IN>;
	chomp $seq;
	my $len = length $seq;
	my $ct = () = $seq =~ /A|T/g;
	if ($ct/$len >= (1-$error_rate)){
		print OUT $id . $seq . "\n";
	}
}