#!/usr/bin/perl
open (FILE,"HsRefSeq_RS89.fasta") or die $!;
while (<FILE>)
{
	chomp($_);
	$_ =~ s/\r//g;
	if ($_ =~ /^>/)
	{
		$gvar =$_;
		@pipes = split (/\|/, $_);
		$gene{$pipes[1]} = $pipes[1];
	}
	else
	{
		$seq{$pipes[1]} .= $_;
	}
}
while (($a, $b) = each %seq)
{
	#print "$a\t$gene{$a}\n$b\n";
	$seqL = length($b);
	$gene_length{$gene{$a}} .= "$seqL;";
	$b =~ s/([RK])/$1=/g;
	$b =~ s/=P/P/g;
	@split_seq = split (/=/, $b);
	foreach $pep (@split_seq)
	{
		$pep_len = length ($pep);
		if ($pep_len >= 7 && $pep_len <=35)
		{
			$count{$a}++;
		}
		else
		{
			$keep_track{$a}=1;
		}
	}
}
while (($c, $d) = each %count)
{
	$ibaq{$gene{$c}} .= "$d;";
}
while (($e, $f) = each %ibaq)
{
	@peptides = split (/\;/, $f);
	@sorted = sort {$a <=> $b} @peptides;
	
	@prtlen = split (/\;/, $gene_length{$e});
	@sorted_prtlen = sort {$a <=> $b} @prtlen;
	print "$e#$sorted[-1]#$sorted_prtlen[-1]\n";
}
