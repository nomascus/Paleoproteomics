#!/usr/bin/perl
use strict;
use warnings;

my $MQrun = shift @ARGV;
my $DBlist = shift @ARGV;

open(IN, '<', $DBlist) or die "$! list of database files did not load\n";

my $header = "Database\tProtein\tProteinGroup\tnSAPs\tSAPs\tCoverage\tnAlignedSeqs\tProteinLength\tnAAs";

print "$header\n";

while (my $META = <IN>){
	chomp $META;
	my @splitMETA = split("\t", $META);
	my $DB = $splitMETA[5]; 
	my $file = '/home/orkin/scratch/PALEOPROTEOMICS/GrandPepRuns/Dolichopithecus_sp_s2863/Dolichopithecus_sp_s2863_BPP_029-01/Dolichopithecus_sp_s2863_BPP_029-01_' . $DB . '_'. $MQrun . '_SR/results/summary.txt';

	open(FILE, '<', $file) or die "$! $file did not load\n";
	<FILE>;

	while (my $line = <FILE>){
		chomp $line;
		my @sl = split("\t", $line);
		my $PG = $sl[0];
		my $nSAP = $sl[1];
		my $SAP = $sl[2];
		if ($SAP eq ''){$SAP = '-'};
		my $coverage = $sl[3];
		my $nalign = $sl[4];
		my $Plen = $sl[5];

		my @proteinID = split ('_', $PG);
		my $protein = shift(@proteinID);
		my $Pinfo = join(@proteinID, '_');
		my $nAAs = $Plen * $coverage / 100;

		print "$DB\t$protein\t$PG\t$nSAP\t$SAP\t$coverage\t$nalign\t$Plen\t$nAAs\n";
	}
}

=cut

Protein	Number of SAPs	Pos. of SAPs	Coverage	Number of aligned sequences	Protein length
AMELX_PD_0055_AMELX.COLGUE_R008273_A1	1	N30D	67.02	410	191
AMBN_A0A2K5ZJQ9	0		6.81	7	411
ALB_A0A2K6A6R3	0		5.96	13	604
COL17A1_A0A2K6PAW0	0		0.76	1	1445
AMTN_F6VN65	0		3.37	1	208
ENAM_PD_0107_ENAM.RHIROX_R002015_A2	0		6.67	75	1140
