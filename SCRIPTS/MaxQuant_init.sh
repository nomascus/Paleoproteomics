#!/bin/bash
#SBATCH --account=def-orkin
#SBATCH --mail-user=joseph.orkin@upf.edu
#SBATCH --mail-type=ALL
#SBATCH -J BPP001_MQ
#SBATCH -D /scratch/orkin/PALEOPROTEOMICS/GrandPepRuns/Dihoplus_sp_s2093/Dihoplus_sp_s2903_BPP001/Dihoplus_sp_s2903_BPP001_INIT
#SBATCH -o /scratch/orkin/PALEOPROTEOMICS/GrandPepRuns/Dihoplus_sp_s2093/Dihoplus_sp_s2903_BPP001/Dihoplus_sp_s2903_BPP001_INIT/ERROR/Dihoplus_sp_s2903_BPP001_INIT.out
#SBATCH -e /scratch/orkin/PALEOPROTEOMICS/GrandPepRuns/Dihoplus_sp_s2093/Dihoplus_sp_s2903_BPP001/Dihoplus_sp_s2903_BPP001_INIT/ERROR/Dihoplus_sp_s2903_BPP001_INIT.err
#SBATCH --time=0-00:10:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

module load dotnet-core/3.1.8
dotnet /home/orkin/PROGRAMS/MaxQuant_2.0.3.1/bin/MaxQuantCmd.exe /home/orkin/projects/def-orkin/orkin/PALEOPROTEOMICS/MQPAR/Dihoplus_sp_BPP_001_init_MQ2.0.3.0_INIT_mqpar.xml

