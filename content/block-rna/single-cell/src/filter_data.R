
library(Seurat) # Hit no if asked to install miniconda #
library(tidyverse)
library(DropletUtils)
library(tximport)
library(tidyverse)
library(Matrix)
library(tximport)
library(here)

# get absolute path
proj_dir <- here()

# import matrix
tx <- tximport(file.path(proj_dir, "data/pbmc/alevin/quants_mat.gz"),
               type = 'alevin')

# call cells
out <- emptyDrops(tx$counts)

# filter for cell containing droplets
mat <- tx$counts[, which(out$FDR < 0.05)]

# load into a seurat object
so <- CreateSeuratObject(mat,
                         min.cells = 10) # remove genes not expressed in at least 10 cells

# add a fake replicate id to have an interesting variable in the dataset
so$samples <- sample(c("rep1", "rep2"), size = ncol(so), replace = TRUE)
Idents(so) <- "samples"

# calc mito UMIs
so <- PercentageFeatureSet(so, pattern  = "^MT-", col.name = "percent_mito")

# Filter cells based on number of genes and percent mito UMIs
so <- subset(so,
             nFeature_RNA > 250 &   # Remove cells with <250 detected genes
               nFeature_RNA < 2500 &  # Remove cells with >2500 detected genes (could be doublets)
               percent_mito < 10      # Remove cells with >10% mitochondrial reads
)

saveRDS(so, file.path(proj_dir, "data", "pbmc", "pbmc_filtered.rds"))

