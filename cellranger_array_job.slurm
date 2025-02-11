#!/bin/bash
#SBATCH --job-name=cellranger_array
#SBATCH --output=cellranger_%A_%a.out
#SBATCH --error=cellranger_%A_%a.err
#SBATCH --time=48:00:00
#SBATCH --mem=60G
#SBATCH --cpus-per-task=8
#SBATCH --array=0-12  # Adjust this range based on the number of folders/samples
#SBATCH --ntasks=1

# Define base directory where all the sample folders are located
BASE_DIR="/exports/archive/hg-funcgenom-research/Genelab_dataset/OSD-562"

# List all the folders in an array
SAMPLE_FOLDERS=($(ls -d ${BASE_DIR}/GC*/))

# Get the folder corresponding to the current SLURM_ARRAY_TASK_ID
SAMPLE_FOLDER=${SAMPLE_FOLDERS[$SLURM_ARRAY_TASK_ID]}

# Extract sample name (folder name without trailing slash)
SAMPLE_NAME=$(basename ${SAMPLE_FOLDER})

# Set the paths to the FASTQ files (R1 and R2)
FASTQ_PATH="${SAMPLE_FOLDER}${SAMPLE_NAME}_S1_L001_R1_001.fastq.gz"
FASTQ_PATH2="${SAMPLE_FOLDER}${SAMPLE_NAME}_S1_L001_R2_001.fastq.gz"

# Run cellranger count for this sample
/exports/humgen/cnovellarausell/cellranger-8.0.1/cellranger count --id=${SAMPLE_NAME}_output \
                 --fastqs=${SAMPLE_FOLDER} \
                 --sample=${SAMPLE_NAME} \
                 --transcriptome=/exports/humgen/cnovellarausell/refdata-gex-GRCm39-2024-A \
                 --localcores=8 \
                 --localmem=54\
                 --create-bam=false

echo "Processed ${SAMPLE_NAME}"

