#!/usr/bin/perl

#Reads in a multifasta database of UNIPROT formatted sequences and prints out the longest isomer for each species within each protein. Format of header MUST have OS=species followed by GN=protein name. If two isomers are the same length, the first one will be printed. 
# e.g. >tr|A0A096NFU6|A0A096NFU6_PAPAN Ameloblastin OS=Papio anubis OX=9555 GN=AMBN PE=3 SV=2

use strict;
use warnings;
use Data::Dumper;

my $infile = shift @ARGV;

open(IN, '<', $infile) or die "$! fasta database did not load";

my %hash;
my $unihash;

my $header = '';
my $sequence = '';
my $species = '';
my $protein = '';
my $ID = '';

while (my $line = <IN>){
	chomp $line;
	if ($line =~ /^>/){
		$header = $line;
		$sequence = '';
		$species = $line;
		$protein = $line;
		$ID = $line;
		$species =~ s/.*OS=(.*)\sOX=.*/$1/;
		$protein =~ s/.*GN=(.*)\sPE=.*/$1/;
		$ID =~ s/^.*\|(.*)\|.*/$1/;
		$hash{$protein}{$species}{$ID}{'seq'} = $sequence;
		$hash{$protein}{$species}{$ID}{'header'} = $header;

	}
	else{
		$hash{$protein}{$species}{$ID}{'seq'} .= $line;
	}

}

#print Dumper \%hash;

foreach my $proteinkey (sort keys %hash){
	foreach my $specieskey (sort keys %{ $hash{$proteinkey} } ) {
		my $size = 0;
		my $isomerhead = '';
		my $isomerseq = '';
		foreach my $IDkey (sort keys %{ $hash{$proteinkey}{$specieskey} }) {
			my $head = $hash{$proteinkey}{$specieskey}{$IDkey}{'header'};
			my $seq = $hash{$proteinkey}{$specieskey}{$IDkey}{'seq'};
			if (length ($seq) > $size){
				$size = length ($seq);
				$isomerhead = $head;
				$isomerseq = $seq;
			}
		}
		$isomerseq =~ s/(.{1,60})/$1\n/g;
		print "$isomerhead\n$isomerseq";

	}
}
