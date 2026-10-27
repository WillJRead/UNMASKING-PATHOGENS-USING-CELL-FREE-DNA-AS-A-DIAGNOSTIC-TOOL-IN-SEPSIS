#!/bin/bash
#SBATCH --job-name=filterquality
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1
#SBATCH --time=02:00:00
#SBATCH --mem=32GB
#SBATCH --error=/lustre/projects/Research_Project-T128783/wr279-project-folder/logs/error.txt
#SBATCH --output=/lustre/projects/Research_Project-T128783/wr279-project-folder/logs/output.txt

# =============================================================================
# STEP 02 | Adapter trimming + average-quality filtering
# =============================================================================
# PURPOSE : Remove Illumina adapters and discard reads with mean Phred < 20.
# INPUT   : raw data as .fastq.gz
# OUTPUT  : trimmed data as .fastq.gz
# TOOLS   : Trimmomatic 0.39 (Java 11), 
# PARAMS  : NOTE - After uploading all of my code months later I have misplaced the information on which adapter file was used
#		    Single-end (SE) mode
#		    ILLUMINACLIP: after adapter_fi:2:30:10  (seed mismatches : palindrome
#           clip threshold : simple clip threshold); AVGQUAL:20
# PREV    : 01_pre_filter_qc.sh  (FIXME: copy/rename step into temp/ not documented)
# NEXT    : 03_post_filter_qc.sh
# =============================================================================

# --- Environment -------------------------------------------------------------
module load Trimmomatic/0.39-Java-11

# --- Variables -------------------------------------------------------------
NAME_OF_GROUP= # I ran this twice one for control and sepsis groups

# --- Paths -------------------------------------------------------------------
BASE=/lustre/projects/Research_Project-T128783/wr279-project-folder
IN_DIR=${BASE}/rawdata/raw/"$NAME_OF_GROUP"/temp
OUT=${IN_DIR}/new_temp
TRIMLOG=${BASE}/logs/trimlog.txt   
R1_FILES=${IN_DIR}/*_1_filter.fastq.gz
R2_FILES=${IN_DIR}/*_2_filter.fastq.gz

mkdir -p "$OUT"

# --- Show available adapter files --
ls $EBROOTTRIMMOMATIC/adapters/

# --- R1 reads ----------------------------------------------------------------
for R1 in $R1_FILES; do
	# Strip the suffix so output keeps the same name as the input
	BASENAME_R1=$(basename "$R1" _filter.fastq.gz)
	java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar SE -threads 4 \
		-trimlog "$TRIMLOG" \
		"$R1" "$OUT/${BASENAME_R1}_filter.fastq.gz" \
		ILLUMINACLIP:$EBROOTTRIMMOMATIC/adapters/${1}:2:30:10 \
		AVGQUAL:20
done

# --- R2 reads (same as R1) ------------------------------------------
for R2 in $R2_FILES; do
	BASENAME_R2=$(basename "$R2" _filter.fastq.gz)
	java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar SE -threads 4 \
		-trimlog "$TRIMLOG" \
		"$R2" "$OUT/${BASENAME_R2}_filter.fastq.gz" \
		ILLUMINACLIP:$EBROOTTRIMMOMATIC/adapters/${1}:2:30:10 \
		AVGQUAL:20
done
