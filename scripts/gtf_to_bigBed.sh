#!/bin/bash

# Load modules
module load kent_tools/486

# Add hg38.p13 chrom sizes
cp /scratch/nxu/astrocytes/data/hg38.p13.GENCODE_chrom.size proc/hg38.chrom.sizes

# Convert supplemented collaborator GTF to bigBed format
gtfToGenePred /scratch/nxu/astrocytes/nextflow_results/translatome/supplemented_collaborator/supplemented_collaborator.gtf proc/input.genePred

genePredToBed proc/input.genePred proc/input.bed

sort -k1,1 -k2,2n proc/input.bed > proc/input.sorted.bed

bedToBigBed proc/input.sorted.bed proc/hg38.chrom.sizes hg38/supplemented_collaborator_translatome.bb

# Convert ORFanage GTF to bigBed format
gtfToGenePred /scratch/nxu/astrocytes/nextflow_results/orfanage/minlen/orfanage.gtf proc/input.genePred

genePredToBed proc/input.genePred proc/input.bed

sort -k1,1 -k2,2n proc/input.bed > proc/input.sorted.bed

bedToBigBed proc/input.sorted.bed proc/hg38.chrom.sizes hg38/orfanage.bb

# Convert collaborator GTF to bigBed format
gtfToGenePred /scratch/nxu/astrocytes/nextflow_results/translatome/supplemented_collaborator/filtered_output_fixed.gtf proc/input.genePred

genePredToBed proc/input.genePred proc/input.bed

sort -k1,1 -k2,2n proc/input.bed > proc/input.sorted.bed

bedToBigBed proc/input.sorted.bed proc/hg38.chrom.sizes hg38/collaborator.bb

# Peptide track: bigGenePred built by the astrocyte-lrs pipeline (peptideTrackUCSC in post_RiboTIE.nf),
# one item per (ORF, peptide) labelled by sequence and colored by NCORF_PROSIT confidence tier
cp /scratch/nxu/astrocytes/nextflow_results/proteomics/peptides_collaborator.bb hg38/peptides.bb
