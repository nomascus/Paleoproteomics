# Generates MaxQuant runs from input file of format Species\tSampleID\tRunIdentifier. Requires folder structure to be ${species}_${sample}/${species}_${sample}_${BPP}/${species}_${sample}_${BPP}_$MQrun (e.g. Dihoplus_sp_s2093/Dihoplus_sp_s2903_BPP001/Dihoplus_sp_s2903_BPP001_INIT) and mqpar files to be named following the structure in the MQpar variable 

# ~/SCRIPTS/MaxQuant_batch.sh INIT metadata.txt
# ~/SCRIPTS/MaxQuant_batch.sh VAL metadata.txt

mqpardir='/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/MQPAR'
indir='/scratch/orkin/PALEOPROTEOMICS/GrandPepRuns'
fastadir='/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/DATABASES'
rawdir='/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/RAW_FILES'
MQrun=$1

cat $2 | while read line; do

	species=$(echo $line | perl -lane 'print $F[0]')
	sample=$(echo $line | perl -lane 'print $F[1]')
	BPP=$(echo $line | perl -lane 'print $F[2]')
	rawfile=$(echo $line | perl -lane 'print $F[3]')
	fastaDB=$(echo $line | perl -lane 'print $F[4]')

	rawfile=$(echo $rawdir/$rawfile)
	fastaDB=$(echo ${fastadir}/$fastaDB)

	MQpar="${species}_${sample}_${BPP}_${MQrun}_mqpar.xml"
	folder=${species}_${sample}/${species}_${sample}_${BPP}/${species}_${sample}_${BPP}_$MQrun
	experiment=$(echo ${species}_${sample}_${BPP})

#	echo $rawfile $fastaDB $experiment 

	mkdir -p $mqpardir

	cat $3 | while read MQPAR; do

		echo $MQPAR |perl -slne 'if ($_ =~ /FASTAFILEPATH/) {$_ =~ s/(.*)(FASTAFILEPATH)(.*)/$1$fasta$2/; print $_}' -- -fasta$fastaDB

		echo $MQPAR |perl -slne 'if ($_ =~ /FIXEDCOMBINEDFOLDER/) {$_ =~ s/(.*)(FIXEDCOMBINEDFOLDER)(.*)/$1$fcf$2/; print $_}' -- -fcf=$folder
		#<fixedCombinedFolder>/scratch/orkin/PALEOPROTEOMICS/GrandPepRuns/Dihoplus_sp_s2093/Dihoplus_sp_s2903_BPP001/Dihoplus_sp_s2903_BPP001_INIT</fixedCombinedFolder>

#	echo $line |perl -lne 'if ($_ =~ /RAWFILE/) {$_ =~ s/(.*)(RAWFILE)(.*)/$1$RF$2/; print $_}' -- -RF=$rawfile
		#<string>/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/RAW_FILES/Dihoplus_sp_s2093_BPP001_2021LZ033_JOOR_001_01_45pto.raw</string>	

		echo $MQPAR |perl -slne 'if ($_ =~ /EXPERIMENT/) {$_ =~ s/(.*)(EXPERIMENT)(.*)/$1$exp$2/; print $_}' -- -exp=$experiment
	done
done
