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

# GitHub-only packages
remotes::install_github("hadley/emo", upgrade = "never")
remotes::install_github("rnabioco/cpp11bigwig", upgrade = "never")

# CRAN packages where conda-forge version is too old
install.packages("valr")
install.packages("Seurat")

# Bioconductor packages not on bioconda or missing osx-arm64 builds
BiocManager::install(c(
  # rGADEM removed from Bioconductor 3.22
  "universalmotif",
  "DropletUtils",
  "scran",
  "memes",
  "alevinQC",
  "clustifyr",
  "clustifyrdatahub"
), update = FALSE, ask = FALSE)
