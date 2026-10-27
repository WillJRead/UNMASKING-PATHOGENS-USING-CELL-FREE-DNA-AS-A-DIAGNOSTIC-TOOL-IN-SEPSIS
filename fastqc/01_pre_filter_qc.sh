#!/bin/bash
#SBATCH --job-name=qc_pre
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=16GB
#SBATCH --output=/lustre/projects/Research_Project-T128783/wr279-project-folder/logs/qc_%j.out
#SBATCH --error=/lustre/projects/Research_Project-T128783/wr279-project-folder/logs/qc_%j.err

# =============================================================================
# STEP 01 | Pre-filter quality control
# =============================================================================
# PURPOSE : Baseline read-quality report (FastQC) on the raw reads BEFORE
#           any trimming/filtering.
# INPUT   : raw reads as .fastq.gz   
# OUTPUT  : .html + .zip per file giving summary of read quality
# TOOLS   : FastQC 0.12.1 (Java 11)
# NEXT    : 02_filter_by_quality.sh
# =============================================================================

# --- Environment -------------------------------------------------------------
module load FastQC/0.12.1-Java-11

# --- Paths -------------------------------------------------------------------
# FIXME: original run used a directory from a dropped dataset; set to the raw-read
# directory actually used for the thesis data.
IN_DIR=/lustre/projects/Research_Project-T128783/wr279-project-folder/rawdata/<RAW_READS_DIR>
OUT_DIR=${IN_DIR}/qc

mkdir -p "$OUT_DIR"   # ADDED: FastQC fails if -o directory is missing

# --- Run FastQC on every raw fastq -------------------------------------------
fastqc -o "$OUT_DIR" "$IN_DIR"/*.fastq.gz
