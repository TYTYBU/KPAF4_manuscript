#!/usr/bin/perl

$infile = $ARGV[0];
$outfile = $ARGV[1];
$prefix = $ARGV[2];

open IN, "<", $infile or die;
open OUT , ">", $outfile or die;

$num0 = 0;
while (my $id = <IN>)
{
	my $seq = <IN>;
	my $ct = 1;
	if ($id =~ /_x([\d]+)/){
		$ct = $1;
	}
	$hash{$seq} += $ct;
	$num0 += $ct;
}

$num = 0;
foreach my $seq (sort {$hash{$b} <=> $hash{$a}} keys %hash)
{
	print OUT ">" . $prefix . "_" . ($num+1) . "_x" . $hash{$seq} . "\n";
	print OUT $seq;
	$num++;
}

print $num0 . " sequences collapsed to " . $num . " sequences.\n";