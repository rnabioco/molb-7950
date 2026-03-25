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

# Bioconductor packages missing osx-arm64 builds (linux-64 gets them from conda)
BiocManager::install(c(
  "alevinQC",
  "memes",
  "scran",
  "universalmotif",
  "DropletUtils"
), update = FALSE, ask = FALSE)
