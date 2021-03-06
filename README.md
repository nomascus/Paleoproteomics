# Paleoproteomics

## 1) MQpar_INIT_autogen.pl

>	This script will generate mqpar files for MaxQuant using a template file, a metadata file, and a intiailization or validation command line switch. The template file includes several allcaps fields (FASTAFILEPATH FIXEDCOMBINEDFOLDER RAWFILE EXPERIMENT) that are replaced using info from the metadatafile and some hard coded paths (see "Set directories" in the script).

>	It will generate mqpar files from metadata file which has the format of sampleID runID rawfile fastaDBfile. For example, the metadata should be something like:     Homo_sapiens    sample123       run456       MassSpec123456.raw      LemurDatabase.fasta

>       For the initialiation run, type: perl MQpar_INIT_autogen.pl template_INIT_mqpar.xml metadata.txt

>	Be sure to hard code the directories in the "Set directories" section below

>	This requires that you follow a particular directory structure on your cluster based upon the fields in the metadata file. Once you hard code the "indir" variable, from there it will generate subfolders in the format of ${species}_${sample}/${species}_${sample}_${BPP}/${species}_${sample}_${BPP}_$MQrun (e.g. Homo_sapiens_s123/Homo_sapiens_sample123_run456/Homo_sapiens_sample123_run456_INIT) and mqpar files to be named following the structure in the MQpar variable


## 2) MaxQuant_batch.sh

>	Generates sbatch files to run MaxQuant according to the structure above. Operates both on INIT and VAL runs. # Generates mqpar files MaxQuant runs from input file of format Species\tSampleID\tRunIdentifier and a choice if an initilization or validation run
>  	For example, the input should be something like:     Homo_sapiens    sample123       run456
>       For the initialiation tun, type: bash MaxQuant_batch.sh INIT metadata.txt
>       For the validation run type: bash MaxQuant_batch.sh VAL metadata.txt

>	This requires that you follow a particular directory structure on your cluster based upon the fields int the metadata file. Once you hard code the "indir" variable (below), from there it will generate subfolders in the format of ${species}_${sample}/${species}_${sample}_${BPP}/${species}_${sample}_${BPP}_$MQrun (e.g. Homo_sapiens_s123/Homo_sapiens_sample123_run456/Homo_sapiens_sample123_run456_INIT) and mqpar files to be named following the structure in the MQpar variable

## 3) SRpar_autogen.pl

>	Generates SRpar files as above. HOWEVER, you need to tell it whether you are doing an INIT or VAL run. For example perl SRpar_autogen.pl INIT template  metadata

## 4)  MQpar_VAL_autogen.pl
>	Same basic idea as  MQpar_INIT_autogen.pl, but includes the newly generated fasta files from the init runs. This can break if there if both peptide and protein fasta tables not output from prior runs. This script is a bit more experimental.  
>       For the validation run type: perl MQpar_VAL_autogen.pl template_VAL_mqpar.xml metadata.txt
	 
## Other scripts

## uniprot_parser.pl
>	Reads in a multifasta database of UNIPROT formatted sequences and prints out the longest isomer for each species within each protein. Format of header MUST have OS=species followed by GN=protein name. If two isomers are the same length, the first one will be printed.
>	 e.g. >tr|A0A096NFU6|A0A096NFU6_PAPAN Ameloblastin OS=Papio anubis OX=9555 GN=AMBN PE=3 SV=2


