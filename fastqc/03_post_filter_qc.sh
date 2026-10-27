#!/bin/bash
#SBATCH --job-name=qc_post
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=16GB
#SBATCH --time=00:15:00
#SBATCH --output=/lustre/projects/Research_Project-T128783/wr279-project-folder/logs/qc_%j.out
#SBATCH --error=/lustre/projects/Research_Project-T128783/wr279-project-folder/logs/qc_%j.err
#SBATCH --nodelist=comp095

# =============================================================================
# STEP 03 | Post-filter quality control
# =============================================================================
# PURPOSE : FastQC on filtered reads to confirm trimming/filtering worked and
#           to compare against the step 01 baseline.
# INPUT   : trimmed reads as .fastq.gz   
# OUTPUT  : .html + .zip per file giving summary of read quality
# TOOLS   : FastQC/0.12.1-Java-11
# RUN     : sbatch 03_post_filter_qc.sh
# PREV    : 02_filter_by_quality.sh
# NOTES   : - FIXME: step 02 writes to temp/new_temp/, but this glob reads
#             temp/ (the INPUT of step 02). Likely QC'ing untrimmed reads.
#             Intended input is probably temp/new_temp/*_filter.fastq.gz.
#           - FIXME: FastQC version differs from step 01 (0.12.1) - reports are
#             not strictly comparable.
#           - --nodelist=comp095 pins the job to one node (presumably because
#             this older module is available there).
# =============================================================================

# --- Environment -------------------------------------------------------------
module load FastQC/0.12.1-Java-11

# --- Paths -------------------------------------------------------------------
IN_DIR=/lustre/projects/Research_Project-T128783/wr279-project-folder/rawdata/raw/NTC/temp
OUT_DIR=/lustre/projects/Research_Project-T128783/wr279-project-folder/rawdata/raw/NTC/fastqc_post

mkdir -p "$OUT_DIR"   # ADDED: FastQC fails if -o directory is missing

# --- Run FastQC on filtered fastqs -------------------------------------------
fastqc -o "$OUT_DIR" "$IN_DIR"/*_filter.fastq.gz
