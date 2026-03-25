# Verify all required packages are loadable.
# Run with: pixi run check-env

required_packages <- c(
  # tidyverse & core
  "tidyverse", "dplyr", "ggplot2", "purrr", "readr", "stringr",
  "broom", "conflicted", "glue", "here", "fs", "janitor",
  "jsonlite", "knitr", "scales", "rstatix",

  # visualization
  "cowplot", "patchwork", "ggpubr", "ggrepel", "ggridges",
  "ggtext", "ggforce", "ggseqlogo", "pheatmap", "gt",
  "DiagrammeR", "RColorBrewer", "viridis", "ragg",
  "ComplexHeatmap", "emojifont", "reactable", "msigdbr",

  # Bioconductor core
  "DESeq2", "GenomicRanges", "Biostrings", "BSgenome",
  "rtracklayer", "Rsamtools", "GenomicAlignments",
  "GenomicFeatures", "AnnotationDbi", "AnnotationHub",
  "SummarizedExperiment", "tximport", "fgsea",
  "clusterProfiler", "enrichplot",

  # Bioconductor analysis
  "Gviz", "biomaRt", "ensembldb", "annotatr",
  "memes", "universalmotif", "regioneR", "GeneOverlap",
  "ggtree", "treeio",

  # Bioconductor data/annotation
  "BSgenome.Hsapiens.UCSC.hg19",
  "BSgenome.Scerevisiae.UCSC.sacCer3",
  "TxDb.Hsapiens.UCSC.hg19.knownGene",
  "TxDb.Scerevisiae.UCSC.sacCer3.sgdGene",
  "org.Hs.eg.db", "GO.db",

  # single-cell
  "SingleCellExperiment", "scran", "scater",
  "DropletUtils", "bluster",

  # fallback packages (installed via install-pak-deps.R)
  "emo", "cpp11bigwig", "valr",
  "alevinQC", "clustifyr", "clustifyrdatahub", "Seurat",
  "universalmotif", "DropletUtils", "scran", "memes",

  # other
  "remotes", "downlit", "fontawesome", "palmerpenguins",
  "googlesheets4", "showtext"
)

results <- vapply(
  required_packages,
  requireNamespace,
  logical(1),
  quietly = TRUE
)
missing <- names(results[!results])

if (length(missing) > 0) {
  cat("MISSING packages:\n")
  cat(paste(" -", missing, collapse = "\n"), "\n")
  quit(status = 1)
} else {
  cat("All", length(results), "required packages available.\n")
}
