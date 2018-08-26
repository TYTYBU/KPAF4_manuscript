#!/usr/bin/perl

$infile = $ARGV[0];
open IN, "<", $infile or die;

$total_ct = 0;
while ($id = <IN>){
	if ($id =~ />/){
		my $seq = <IN>;
		my $ct = 1;
		if ($id =~ /_x([\d]+)/){
			$ct = $1;
		}
		$total_ct += $ct;
	}
}
print $total_ct . "\t" . $infile . "\n";
