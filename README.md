# cfDNA Metagenomic Classification Pipeline

Thesis project code: cell-free DNA (cfDNA) sequencing with metagenomic
taxonomic classification. Scripts run on a SLURM HPC cluster and are numbered
in the order they were executed.

## Repository layout

```
scripts/
  01_pre_filter_qc.sh
  02_filter_by_quality.sh
  03_post_filter_qc.sh
logs/            # SLURM stdout/stderr (not tracked)
```

## Pipeline overview

| Step | Script | What it does | Input | Output |
|------|--------|--------------|-------|--------|
| 01 | `01_pre_filter_qc.sh` | FastQC on raw reads | raw `.fastq.gz` | `qc/` reports |
| 02 | `02_filter_by_quality.sh` | Adapter trimming + mean-quality filter | `*_{1,2}_filter.fastq.gz` | `temp/new_temp/*_filter.fastq.gz` |
| 03 | `03_post_filter_qc.sh` | FastQC on filtered reads | filtered `.fastq.gz` | `fastqc_post/` reports |

## Data

- <!-- TODO: describe cfDNA sample cohort, accession numbers, read length -->
- NTC = non-template control samples.

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

## Known issues / consistency log

Track anything that doesn't line up between steps here; resolve or explain
before publishing.

| # | Step(s) | Issue | Status |
|---|---------|-------|--------|
| 1 | 02 -> 03 | Step 03 reads `temp/`, step 02 outputs to `temp/new_temp/` | Open |
| 2 | 01 -> 02 | Step 01 input directory is unconfirmed, and the step that placed files into `temp/` with `_filter` suffix is undocumented | Open |
| 3 | 02 | Adapter file passed as `${1}`; unclear if supplied at run time | Open |
| 4 | 02 | R1/R2 filtered separately (SE mode) | Resolved - intentional (5' ends only) |
| 5 | 02 | `-threads 4` vs `--cpus-per-task=1` | Open |
| 6 | 01 / 03 | FastQC versions differ (0.12.1 vs 0.11.7) | Open |

## Script commenting convention

Every script starts with the SBATCH block, then a header with: STEP, PURPOSE,
INPUT, OUTPUT, TOOLS, RUN, PREV/NEXT, NOTES. Sections inside the script use
`# --- Section ---` dividers. Tags: `NOTE` (context), `WARNING` (can cause
wrong results), `FIXME` (known problem to resolve), `ADDED` (changed after the
original run).
