# Generates mqpar files MaxQuant runs from input file of format Species\tSampleID\tRunIdentifier and a choice if an initilization or validation run
	## For example, the input should be something like:	Homo_sapiens	sample123	run456
	## For the initialiation tun, type: bash MaxQuant_batch.sh INIT metadata.txt 
	## For the validation run type: bash MaxQuant_batch.sh VAL metadata.txt

# This requires that you follow a particular directory structure on your cluster based upon the fields int the metadata file. Once you hard code the "indir" variable (below), from there it will generate subfolders in the format of ${species}_${sample}/${species}_${sample}_${BPP}/${species}_${sample}_${BPP}_$MQrun (e.g. Homo_sapiens_s123/Homo_sapiens_sample123_run456/Homo_sapiens_sample123_run456_INIT) and mqpar files to be named following the structure in the MQpar variable 

# Set directories

comdir='/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/COMMANDS' # sbatch commands will be saved in the COMMANDS folder. Change this as you see fit

mqpardir='/home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/MQPAR' # This should already have been created in the autogen step, but if not, set this to your local directory where you store yoy want to save your MQPAR files AND you store your template files

indir='/scratch/orkin/PALEOPROTEOMICS/GrandPepRuns' # Set this directory to the location where you want to save the results of your MaxQuant runs.

mkdir -p $comdir

MQrun=$1

cat $2 | while read line; do

	#species=$(echo $line | awk '{print $1}')
	species=$(echo $line | perl -lane 'print $F[0]')
	sample=$(echo $line | perl -lane 'print $F[1]')
	BPP=$(echo $line | perl -lane 'print $F[2]')
	DBID=$(echo $line | perl -lane 'print $F[5]')

	MQpar="${species}_${sample}_${BPP}_${DBID}_${MQrun}_mqpar.xml"
	folder=${species}_${sample}/${species}_${sample}_${BPP}/${species}_${sample}_${BPP}_${DBID}_$MQrun
	
	mkdir -p $indir/$folder
	mkdir -p $indir/$folder/ERROR

echo "#!/bin/bash

#SBATCH --account=def-orkin
#SBATCH --mail-user=joseph.orkin@umontreal.ca
#SBATCH --mail-type=ALL
#SBATCH -J ${DBID}_${BPP}_MQ
#SBATCH -D $indir/$folder
#SBATCH -o $indir/$folder/ERROR/${species}_${sample}_${BPP}_${DBID}_${MQrun}-%j.out
#SBATCH -e $indir/$folder/ERROR/${species}_${sample}_${BPP}_${DBID}_${MQrun}-%j.err
#SBATCH --time=0-18:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=4G

export OMP_NUM_THREADS=\$SLURM_CPUS_PER_TASK

module load dotnet-core/3.1.8
dotnet /home/orkin/PROGRAMS/MaxQuant_2.0.3.1/bin/MaxQuantCmd.exe ${mqpardir}/$MQpar" > $comdir/${species}_${sample}_${BPP}_${DBID}_${MQrun}.sbatch

done
