# Install R packages not available on conda-forge/bioconda.
# Run with: pixi run install-pak-deps

options(repos = c(
  CRAN = "https://cran.rstudio.com"
))

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

# Helper: only install if not already available
install_if_missing <- function(pkgs, ...) {
  missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) > 0) {
    BiocManager::install(missing, update = FALSE, ask = FALSE, ...)
  }
}

# GitHub-only packages
if (!requireNamespace("emo", quietly = TRUE)) {
  remotes::install_github("hadley/emo", upgrade = "never")
}
if (!requireNamespace("cpp11bigwig", quietly = TRUE)) {
  remotes::install_github("rnabioco/cpp11bigwig", upgrade = "never")
}

# CRAN packages where conda-forge version is too old
install_if_missing(c("valr", "Seurat"))

# Bioconductor packages missing osx-arm64 builds (linux-64 gets them from conda)
install_if_missing(c(
  "alevinQC",
  "memes",
  "scran",
  "universalmotif",
  "DropletUtils",
  "GO.db",
  "TxDb.Hsapiens.UCSC.hg19.knownGene",
  "org.Hs.eg.db",
  "BSgenome.Hsapiens.UCSC.hg19",
  "TxDb.Scerevisiae.UCSC.sacCer3.sgdGene",
  "BSgenome.Scerevisiae.UCSC.sacCer3",
  "clustifyrdatahub",
  "rGADEM",
  "seqLogo"
))
