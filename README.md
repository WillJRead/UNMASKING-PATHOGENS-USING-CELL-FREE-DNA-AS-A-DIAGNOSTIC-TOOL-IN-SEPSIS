# cfDNA Metagenomic Classification Pipeline

Cell-free DNA (cfDNA) sequencing with metagenomic
taxonomic classification. Scripts run on a SLURM HPC cluster and are numbered
in the order they were executed.

## Repository layout

```
scripts/
  01_pre_filter_qc.sh
  02_filter_by_quality.sh
  03_post_filter_qc.sh
logs/
```

## Pipeline overview

| Step | Script | What it does | Input | Output |
|------|--------|--------------|-------|--------|
| 01 | `01_pre_filter_qc.sh` | FastQC on raw reads | raw `.fastq.gz` | `qc/` reports |
| 02 | `02_filter_by_quality.sh` | Adapter trimming + mean-quality filter | `*_{1,2}_filter.fastq.gz` | `temp/new_temp/*_filter.fastq.gz` |
| 03 | `03_post_filter_qc.sh` | FastQC on filtered reads | filtered `.fastq.gz` | `fastqc_post/` reports |

## Data

## Step details

### 1. Quality assurance (steps 01-03)

**01 Pre-filter QC.** FastQC (v0.12.1) on the raw reads to
establish baseline per-base quality, adapter content and duplication levels.

**02 Filtering.** Trimmomatic 0.39: `ILLUMINACLIP:<adapter>:2:30:10` removes
adapters; `AVGQUAL:20` discards reads with mean Phred score below 20. R1 and
R2 were processed separately in single-end mode, as only the 5' end of
each read is used downstream (pairing not required).
<!-- TODO: state which adapter file was used -->

**03 Post-filter QC.** FastQC (v0.11.7) on the filtered reads to confirm
improvement relative to step 01.

## Script commenting convention

Every script starts with the SBATCH block, then a header with: STEP, PURPOSE,
INPUT, OUTPUT, TOOLS, RUN, PREV/NEXT, NOTES. Sections inside the script use
