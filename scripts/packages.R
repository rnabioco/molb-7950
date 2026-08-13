# Single source of truth for the R packages the course materials need.
#
# Consumed by:
#   scripts/setup-posit-cloud.R  -- yearly Posit Cloud base-project setup
#   scripts/install-pak-deps.R   -- installs whatever the conda env didn't supply
#   scripts/check-env.R          -- verifies everything is loadable
#
# This file must stay pure data with no dependencies: setup-posit-cloud.R
# source()s it over https from a blank Posit Cloud project.
#
# Adding a package? Add it here AND to pixi.toml (under its conda name).
#
# Deliberately excluded: gganimate, gifski, magick, Rtsne, tidyquant, DAAG,
# gapminder, eds. These appear only in underscore-prefixed files that Quarto
# does not render (resources/_plot-competition*.qmd, exercises/_ex-31.qmd).
# Add them here if those files are ever un-prefixed.

cran_pkgs <- c(
  # tidyverse & core
  "tidyverse",
  "dplyr",
  "ggplot2",
  "purrr",
  "readr",
  "stringr",
  "magrittr",
  "broom",
  "conflicted",
  "glue",
  "here",
  "fs",
  "janitor",
  "jsonlite",
  "knitr",
  "yaml",
  "scales",
  "rstatix",
  "tidymodels",
  "matrixStats",
  "Matrix",
  "igraph",

  # visualization
  "cowplot",
  "patchwork",
  "ggpubr",
  "ggrepel",
  "ggridges",
  "ggtext",
  "ggforce",
  "ggseqlogo",
  "pheatmap",
  "gt",
  "DiagrammeR",
  "RColorBrewer",
  "viridis",
  "viridisLite",
  "ragg",
  "jpeg",
  "Hmisc",
  "emojifont",
  "reactable",
  "showtext",

  # genomics on CRAN (not Bioconductor)
  "valr",
  "cpp11bigwig",
  "msigdbr",
  "Seurat",

  # tooling & data
  "remotes",
  "BiocManager",
  "downlit",
  "fontawesome",
  "gert",
  "googlesheets4",
  "palmerpenguins",
  "tidytree",
  "cmdfun",
  "usethis"
)

bioc_pkgs <- c(
  # Bioconductor core
  "BiocGenerics",
  "BiocParallel",
  "IRanges",
  "S4Vectors",
  "GenomeInfoDb",
  "GenomicRanges",
  "Biostrings",
  "BSgenome",
  "rtracklayer",
  "Rsamtools",
  "GenomicAlignments",
  "GenomicFeatures",
  "AnnotationDbi",
  "AnnotationHub",
  "SummarizedExperiment",
  "VariantAnnotation",
  "DESeq2",
  "tximport",
  "fgsea",
  "clusterProfiler",
  "enrichplot",
  "DOSE",
  "GOSemSim",
  "ComplexHeatmap",

  # Bioconductor visualization & analysis
  "Gviz",
  "biovizBase",
  "annotatr",
  "biomaRt",
  "ensembldb",
  "regioneR",
  "GeneOverlap",
  "ggtree",
  "treeio",
  "memes",
  "universalmotif",
  "seqLogo",

  # Bioconductor annotation/data packages
  "BSgenome.Hsapiens.UCSC.hg19",
  "BSgenome.Scerevisiae.UCSC.sacCer3",
  "TxDb.Hsapiens.UCSC.hg19.knownGene",
  "TxDb.Scerevisiae.UCSC.sacCer3.sgdGene",
  "org.Hs.eg.db",
  "GO.db",

  # single-cell
  "SingleCellExperiment",
  "scater",
  "scran",
  "DropletUtils",
  "bluster",
  "clustifyr",
  "clustifyrdatahub",
  "alevinQC"
)

# named vector: names are package names, values are install specs
github_pkgs <- c(emo = "hadley/emo")
