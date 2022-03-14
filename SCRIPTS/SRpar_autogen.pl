#!/usr/bin/perl
use strict;
use warnings;

# Set directories 
my $srpardir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/SRPAR';
my $mqpardir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/MQPAR';
my $indir = '/scratch/orkin/PALEOPROTEOMICS/GrandPepRuns';
my $fastadir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/DATABASES';
#my $rawdir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/RAW_FILES';

# List command line parameters
my $MQrun = shift @ARGV; # INIT or VAL
my $template_file = shift @ARGV; # SRpar file with proper settings but dummy words for bits that need changing
my $metadata_file = shift @ARGV; # Tab delimited file with species sampleID runID rawfile fastaDBfile

open(META, '<', $metadata_file) or die "Metadata file did not load $! \n";

while (my $line = <META>){
	
	# Parse metadata file
	chomp $line;
	my @splitline = split("\t" , $line);
	my $species = $splitline[0];	
	my $sample = $splitline[1];
	my $BPP = $splitline[2];
	my $rawfile = $splitline[3];
	my $fastaDB = $splitline[4];

	# Add a few more variables
        my $SRpar = join ("_", $species,$sample,$BPP,$MQrun,"srpar.xml");
        my $MQpar = join ("_", $species,$sample,$BPP,$MQrun,"mqpar.xml");
        my $SRfolder = $species . '_' . "$sample/$species" . '_' . $sample . '_' . "$BPP/$species" . '_' . $sample . '_' . $BPP . '_' . $MQrun . '_SR';
	my $MQfolder = $species . '_' . "$sample/$species" . '_' . $sample . '_' . "$BPP/$species" . '_' . $sample . '_' . $BPP . '_' . $MQrun;
	my $experiment = join("_",$species,$sample,$BPP);

	# Edit variables to include paths
#	$rawfile = join("/",$rawdir,$rawfile);
        $fastaDB = join("/",$fastadir,$fastaDB);

	# create backup of combined folder
	my $cmd = "cp -r $indir/$MQfolder/combined $indir/$MQfolder/combined_backup";
	#print "$cmd\n";
	system ($cmd);
	
	# make internal FASTA directory and copy fasta databases there
  	 my $cmd2 = "mkdir -p $indir/$SRfolder; mkdir -p $indir/$SRfolder/FASTA; cp $fastaDB $indir/$SRfolder/FASTA"; # Need to check which fasta files should be in here...
	#my $cmd2 = "mkdir -p $indir/$SRfolder; mkdir -p $indir/$SRfolder/FASTA; cp $indir/$MQfolder/FASTA/*.fasta $indir/$SRfolder/FASTA"; # Need to check which fasta files should be in here...
	#print "$cmd2\n";
	system($cmd2);

	# copy MQpar file to INIT folder
	my $cmd3 = "cp $mqpardir/$experiment" . "_" . "$MQrun" ."_mqpar.xml $indir/$MQfolder";
#	print "$cmd3\n";
	system($cmd3);

	open(OUT, '>', "$srpardir/$experiment" . "_" . "$MQrun" ."_srpar.xml") or die "$! Outfile did not load\n";

print "Species: $species\nSample: $sample\nRun: $BPP\nrawfile: $rawfile\nfastaDB: $fastaDB\nSRpar: $SRpar\nSRfolder: $SRfolder\nSRpar: $SRpar\nMQfolder: $MQfolder\nMQPAR: $MQpar\nexperiment: $experiment\n\n";


	open(SRPAR, '<', $template_file) or die "SRpar template did not load $! \n";
	
	while (my $parline = <SRPAR>){
		chomp $line;

		if ($parline =~ /MQRESDIR/){
			$parline =~ s/(.*)MQRESDIR(.*)/$1$indir\/$MQfolder$2/; 
			print OUT $parline;
		}
		elsif ($parline =~ /MQPAR/){
			$parline =~ s/(.*)MQPAR(.*)/$1$MQpar$2/; 
			print OUT $parline;
			}
		elsif ($parline =~ /FASTAFILEPATH/){
			$parline =~ s/(.*)FASTAFILEPATH(.*)/$1$indir\/$SRfolder\/FASTA$2/; 
			print OUT $parline;
		}
		elsif ($parline =~ /SRRESDIR/){
			$parline =~ s/(.*)SRRESDIR(.*)/$1$indir\/$SRfolder$2/; 
			print OUT $parline;
		}
		else {
			print OUT $parline; 
		}
	}	
	close (OUT);
	close (SRPAR);
	
	# copy srpar from projects to specific directory
	my $cmd4 = "cp $srpardir/$experiment" . "_" . "$MQrun" ."_srpar.xml $indir/$SRfolder";
#	print "$cmd4\n";
	system($cmd4);
}
