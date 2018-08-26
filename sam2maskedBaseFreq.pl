#!/usr/bin/perl

$infile = $ARGV[0];
$outfile = $ARGV[1];

open IN, "<", $infile or die; #sam file
open OUT, ">", $outfile or die; #cov file

while (my $line = <IN>){
	if ($line =~ /([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t[^\t]+\t([^\t]+)\t[^\t]\t[^\t]\t[^\t]\t([^\t]+)/){
		my $qid = $1;
		my $flag = $2;
		my $sid = $3;
		my $s_start = $4;
		my $cigar = $5;
		my $q_seq = $6;
		
		my $strand = "+";
		if ($flag & 4){
			next;
		}
		elsif ($flag & 16){
			$strand = "-";
		}
		
		my $ct = 1;
		if ($qid =~ /.*_x([\d]+)/){
			$ct = $1;
		}
		
		my $s_pos = $s_start;
		my $q_pos = 1;
		while ($cigar =~ /([\d]+)([MDIS])/g){
			my $num = $1;
			my $action = $2;
			if ($action eq "M"){
				foreach $n (1 .. $num){
					$hash{$sid}{$s_pos}{$strand}{normal} += $ct;
					$s_pos ++;
					$q_pos ++;
				}
			}
			elsif ($action eq "D"){
				foreach $n (1 .. $num){
					$hash{$sid}{$s_pos}{$strand}{normal} += $ct;
					$s_pos ++;
				}
			}
			elsif ($action eq "I"){
				$q_pos += $num;
			}
			elsif ($action eq "S"){
				my $seq = substr $q_seq, ($q_pos-1), $num;
				$q_pos += $num;
				
				if ($s_pos == $s_start){
					$s_pos -= $num;
				}
				
				foreach $n (split //, $seq){
					$hash{$sid}{$s_pos}{$strand}{masked}{$n} += $ct;
					$s_pos++;
				}
			}
		}
	}
}

print OUT "gene_id\tpos\tf_read\tr_read\tf_A\tf_T\tf_G\tf_C\tr_A\tr_T\tr_G\tr_C\n";
foreach my $gene_id (sort keys %hash){
	foreach my $pos (sort {$a <=> $b} keys %{$hash{$gene_id}}){
		$A1 = 0;
		$T1 = 0;
		$G1 = 0;
		$C1 = 0;
		$A2 = 0;
		$T2 = 0;
		$G2 = 0;
		$C2 = 0;
		$read_f = 0;
		$read_r = 0;
		if (exists $hash{$gene_id}{$pos}{"+"}{normal}) {
			$read_f = $hash{$gene_id}{$pos}{"+"}{normal};
		}
		if (exists $hash{$gene_id}{$pos}{"+"}{masked}){
			if (exists $hash{$gene_id}{$pos}{"+"}{masked}{"A"}){
				$A1 = $hash{$gene_id}{$pos}{"+"}{masked}{"A"};
			}
			if (exists $hash{$gene_id}{$pos}{"+"}{masked}{"T"}){
				$T1 = $hash{$gene_id}{$pos}{"+"}{masked}{"T"};
			}
			if (exists $hash{$gene_id}{$pos}{"+"}{masked}{"G"}){
				$G1 = $hash{$gene_id}{$pos}{"+"}{masked}{"G"};
			}
			if (exists $hash{$gene_id}{$pos}{"+"}{masked}{"C"}){
				$C1 = $hash{$gene_id}{$pos}{"+"}{masked}{"C"};
			} 
		}
		if (exists $hash{$gene_id}{$pos}{"-"}{normal}) {
			$read_r = $hash{$gene_id}{$pos}{"-"}{normal};
		}
		if (exists $hash{$gene_id}{$pos}{"-"}{masked}){
			if (exists $hash{$gene_id}{$pos}{"-"}{masked}{"A"}){
				$A2 = $hash{$gene_id}{$pos}{"-"}{masked}{"A"};
			}
			if (exists $hash{$gene_id}{$pos}{"-"}{masked}{"T"}){
				$T2 = $hash{$gene_id}{$pos}{"-"}{masked}{"T"};
			}
			if (exists $hash{$gene_id}{$pos}{"-"}{masked}{"G"}){
				$G2 = $hash{$gene_id}{$pos}{"-"}{masked}{"G"};
			}
			if (exists $hash{$gene_id}{$pos}{"-"}{masked}{"C"}){
				$C2 = $hash{$gene_id}{$pos}{"-"}{masked}{"C"};
			} 
		}
		
		print OUT $gene_id . "\t" . $pos . "\t" . $read_f . "\t" . $read_r . "\t" . $A1 . "\t" . $T1 . "\t" . $G1 . "\t" . $C1 . "\t" . $A2 . "\t" . $T2 . "\t" . $G2 . "\t" . $C2 . "\n";
	}
}