#!/usr/bin/perl
use strict;
use warnings;

# Set directories 
my $mqpardir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/MQPAR';
my $indir = '/scratch/orkin/PALEOPROTEOMICS/GrandPepRuns';
my $fastadir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/DATABASES';
my $rawdir = '/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/RAW_FILES';
my $MQrun = 'VAL';

# List command line parameters
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
	my $fastafile = $splitline[4];
	my $DBID = $splitline[5];
	
	# Add a few more variables
        my $MQpar = $mqpardir . "/" . join ("_", $species,$sample,$BPP,$DBID,"VAL_mqpar.xml");
        my $folderINIT = $species . '_' . "$sample/$species" . '_' . $sample . '_' . "$BPP/$species" . '_' . $sample . '_' . $BPP . '_' . $DBID . '_INIT';
        my $folderINIT_SR = $species . '_' . "$sample/$species" . '_' . $sample . '_' . "$BPP/$species" . '_' . $sample . '_' . $BPP . '_' . $DBID . '_INIT_SR';
        my $folderVAL = $species . '_' . "$sample/$species" . '_' . $sample . '_' . "$BPP/$species" . '_' . $sample . '_' . $BPP . '_' . $DBID . '_VAL';
        my $folderVAL_SR = $species . '_' . "$sample/$species" . '_' . $sample . '_' . "$BPP/$species" . '_' . $sample . '_' . $BPP . '_' . $DBID . '_VAL_SR';
        my $experiment = join("_",$species,$sample,$BPP,$DBID);
	my $peptidefile = 'gp_peptide_seqs_val.fasta';
	my $proteinfile = 'gp_protein_seqs_rec.fasta';

	# Make folders and copy INIT fastas to VAL dir
	my $cmd = "mkdir -p $indir/$folderVAL; mkdir -p $indir/$folderVAL/FASTA; cp $indir/$folderINIT_SR/results/*.fasta $indir/$folderVAL/FASTA; cp $fastadir/${DBID}.fasta $indir/$folderVAL/FASTA";
#	my $cmd = "mkdir -p $indir/$folderVAL; mkdir -p $indir/$folderVAL/FASTA; cp $indir/$folderINIT_SR/results/*.fasta $indir/$folderVAL/FASTA; cp $fastadir/$fastafile $indir/$folderVAL/FASTA";
#	print "$cmd\n";
	system($cmd);

	# Rename rawfile pto folders generated during INIT run to prevent overwrite
	my $rawroot = $rawfile;
	$rawroot =~ s/\.raw//;
	my $cmd2 = "mv $rawdir/$rawroot $rawdir/$rawroot-INIT";
#	print "$cmd2\n";
	system($cmd2);

	# Edit variables to include paths
	$rawfile = join("/",$rawdir,$rawfile);
        #my $fastaDB = join("/",$fastadir,$fastafile);
        my $fastaDB = join("/",$fastadir,$DBID) . '.fasta';
	my $peptideDB = join("/",$indir,$folderVAL,'FASTA',$peptidefile);
        my $proteinDB = join("/",$indir,$folderVAL,'FASTA',$proteinfile);

	open(OUT, '>', "$mqpardir/$experiment" . "_VAL" ."_mqpar.xml") or die "$! Outfile did not load\n";

print "Species: $species\nSample: $sample\nRun: $BPP\tDatabaseID: $DBID\t\nrawfile: $rawfile\nfastaDB: $fastaDB\nMQpar: $MQpar\nfolderVAL: $folderVAL\nexperiment: $experiment\n\n";

	open(MQPAR, '<', $template_file) or die "MQpar template did not load $! \n";
	
	while (my $parline = <MQPAR>){
		chomp $line;
		if ($parline =~ /PEPTIDEFILEPATH/){
			$parline =~ s/(.*)PEPTIDEFILEPATH(.*)/$1$peptideDB$2/; 
			print OUT $parline;
		}
		elsif ($parline =~ /PROTEINFILEPATH/){
			$parline =~ s/(.*)PROTEINFILEPATH(.*)/$1$proteinDB$2/; 
			print OUT $parline;
		}
		elsif ($parline =~ /FASTAFILEPATH/){
			$parline =~ s/(.*)FASTAFILEPATH(.*)/$1$indir\/$folderVAL\/FASTA\/$DBID\.fasta$2/; 
			print OUT $parline;
		}
		elsif ($parline =~ /FIXEDCOMBINEDFOLDER/){
			$parline =~ s/(.*)FIXEDCOMBINEDFOLDER(.*)/$1$indir\/$folderVAL$2/; 
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
