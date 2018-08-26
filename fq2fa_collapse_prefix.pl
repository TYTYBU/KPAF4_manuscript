#!/usr/bin/perl

$infile = $ARGV[0];
$outfile = $ARGV[1];
$prefix = $ARGV[2];

open IN, "<", $infile or die;
open OUT , ">", $outfile or die;

print "Converting fastQ to fastA with prefix " . $prefix . "\n";

$total_ct = 0;
$N_ct = 0;
$converted_ct = 0;
while (<IN>)
{
	my $seq = <IN>;
	if ($seq =~ /N/)
	{
		$N_ct++;
	}
	else
	{
		$hash{$seq}++;
		$converted_ct++;
	}

	<IN>;
	<IN>;
	$total_ct++;
}

print "Total ct: " . $total_ct . "\n";
print "Sequences with N removed: " . $N_ct . "\n";
print "Seqeunces converted: " . $converted_ct . "\n";

$collapsed_ct = 0;
foreach my $seq (sort {$hash{$b} <=> $hash{$a} or $a cmp $b} keys %hash)
{
	print OUT ">" . $prefix . "_" . $collapsed_ct . "_x" . $hash{$seq} . "\n";
	print OUT $seq;
	$collapsed_ct++;
}

print "Sequences collapsed to: " . $collapsed_ct . "\n";
