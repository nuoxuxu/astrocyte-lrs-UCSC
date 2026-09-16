#!/bin/bash

# Load modules
module load kent_tools/486

# Convert ORFanage GTF to bigBed format
cp /scratch/nxu/astrocytes/data/hg38.p13.GENCODE_chrom.size proc/hg38.chrom.sizes

gtfToGenePred /scratch/nxu/astrocytes/nextflow_results/translatome/supplemented_collaborator/supplemented_collaborator.gtf proc/input.genePred

genePredToBed proc/input.genePred proc/input.bed

sort -k1,1 -k2,2n proc/input.bed > proc/input.sorted.bed

bedToBigBed proc/input.sorted.bed proc/hg38.chrom.sizes hg38/supplemented_collaborator_translatome.bb

# Convert peptide GTF to bigBed format
awk 'BEGIN{OFS="\t"} $3=="exon" {
    # Find the transcript_id
    match($0, /transcript_id "([^"]+)"/, a);
    
    # Print BED6 with Score (Col 5) set to 0
    print $1, $4-1, $5, a[1], "0", $7
}' /scratch/nxu/astrocytes/nextflow_results/proteomic/peptides_collaborator.gtf > proc/peptides.bed

sort -k1,1 -k2,2n proc/peptides.bed > proc/peptides.sorted.bed

bedToBigBed proc/peptides.sorted.bed proc/hg38.chrom.sizes hg38/pep_output.bb