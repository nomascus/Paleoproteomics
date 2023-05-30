#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $printGene = shift @ARGV;
my $infile =  shift @ARGV;

my %hash;
open (IN, '<', $infile) or die "$! fasta file did not load \n";

my $gene = '';
my $ID = '';

while (my $line = <IN>){
	chomp $line;
	if ($line =~ /^>/){
		my @splitline = split ("GN=", $line);
		$gene = $splitline[1];
		my @splitline2 = split ("gpSr_", $line);
		$ID = $splitline2[0];
		$hash{$gene}{$ID}{'header'} = $line;
	}
	else{
		$hash{$gene}{$ID}{'seq'} .= $line;
	}	
}

#print Dumper \%hash;

foreach my $key (sort keys %hash){
	if ($key eq $printGene){
		foreach my $sub_key (sort keys %{$hash{$key}}){
			my $sequence = $hash{$key}{$sub_key}{'seq'};
			chomp $sequence;
			$sequence =~ s/(.{1,80})/$1\n/g;
#			print "$hash{$key}{$sub_key}{'header'}\n$hash{$key}{$sub_key}{'seq'}\n"
			print "$hash{$key}{$sub_key}{'header'}\n$sequence"
		}
	}
}

=cut
for my $key (keys %company) 
{
    print "$key: \n";
    for my $ele (keys %{$company{$key}}) 
    {
        print " $ele: " . $company{$key}->{$ele} . "\n";
    }
}
  


%{ $grades{$name} }
