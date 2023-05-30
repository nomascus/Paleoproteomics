#!/usr/bin/perl

# This script will generate mqpar files for MaxQuant using a template file, a metadata file, and a intiailization or validation command line switch
## The template file includes several allcaps fields (FASTAFILEPATH FIXEDCOMBINEDFOLDER RAWFILE EXPERIMENT) that are replaced using info from the metadatafile and some hard coded paths below.

# It will generate mqpar files from metadata file which has the format of sampleID runID rawfile fastaDBfile DatabaseID
        ## For example, the metadata should be something like:     Homo_sapiens    sample123       run456	MassSpec123456.raw	LemurDatabase.fasta DBB001
	## For the initialiation tun, type: perl MQpar_autogen.pl template_VAL_mqpar.xml metadata.txt
        ## For the validation run use the validation version of this script

# Be sure to hard code the directories in the "Set directories" section below

# This requires that you follow a particular directory structure on your cluster based upon the fields in the metadata file. Once you hard code the "indir" variable (below), from there it will generate subfolders in the format of ${species}_${sample}/${species}_${sample}_${BPP}/${species}_${sample}_${BPP}_${DBID}_$MQrun (e.g. Homo_sapiens_s123/Homo_sapiens_sample123_run456/Homo_sapiens_sample123_run456_DBB001_INIT) and mqpar files to be named following the structure in the MQpar variable

use strict;
use warnings;

# Set directories 
my $mqpardir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/MQPAR'; # Directory where mqpar files will be output. Also include your template mqpars here
my $indir = '/scratch/orkin/PALEOPROTEOMICS/GrandPepRuns';	# Directory where the maxquant results will be generated in subfolders
my $fastadir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/DATABASES';	# Directory that stores your fasta databases
my $rawdir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/RAW_FILES';	#Direcory that stores your mass spec raw files

# List command line parameters
#my $MQrun = shift @ARGV; # INIT or VAL
my $MQrun =  'INIT';
my $template_file = shift @ARGV; # MQpar file with proper settings but dummy words for bits that need changing
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
	my $DBID = $splitline[5];

	# Add a few more variables
        my $MQpar = $mqpardir . "/" . join ("_", $species,$sample,$BPP,$DBID,$MQrun,"mqpar.xml");
        my $folder = $species . '_' . "$sample/$species" . '_' . $sample . '_' . "$BPP/$species" . '_' . $sample . '_' . $BPP . '_' . ${DBID} . '_' . $MQrun;
        my $experiment = join("_",$species,$sample,$BPP,$DBID);

	# Edit variables to include paths
	$rawfile = join("/",$rawdir,$rawfile);
        #$fastaDB = join("/",$fastadir,$fastaDB);
        $fastaDB = join("/",$fastadir,$DBID) . '.fasta';
	
	open(OUT, '>', "$mqpardir/$experiment" . "_" . "$MQrun" ."_mqpar.xml") or die "$! Outfile did not load\n";

print "Species: $species\nSample: $sample\nRun: $BPP\nDatabaseID: $DBID\nrawfile: $rawfile\nfastaDB: $fastaDB\nMQpar: $MQpar\nfolder: $folder\nexperiment: $experiment\n\n";

	open(MQPAR, '<', $template_file) or die "MQpar template did not load $! \n";
	
	while (my $parline = <MQPAR>){
		chomp $line;
		if ($parline =~ /FASTAFILEPATH/){
			$parline =~ s/(.*)FASTAFILEPATH(.*)/$1$fastaDB$2/; 
			print OUT $parline;
		}
		elsif ($parline =~ /FIXEDCOMBINEDFOLDER/){
			$parline =~ s/(.*)FIXEDCOMBINEDFOLDER(.*)/$1$indir\/$folder$2/; 
			print OUT $parline;
		}
		elsif ($parline =~ /RAWFILE/){
			$parline =~ s/(.*)RAWFILE(.*)/$1$rawfile$2/; 
			print OUT $parline;
			}
                elsif ($parline =~ /EXPERIMENT/){
			$parline =~ s/(.*)EXPERIMENT(.*)/$1$experiment$2/; 
			print OUT $parline;
			}

		else {
			print OUT $parline; 
		}
	}	
	close (OUT);
	close (MQPAR);
}
