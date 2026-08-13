# Compare the conda manifest (pixi.toml) against the R manifest
# (scripts/packages.R) and report packages present in one but not the other.
# Run with: pixi run check-manifest

source("scripts/packages.R")

# conda names are lowercased, so map the irregular ones back by hand
irregular <- c(
  "diagrammer" = "DiagrammeR",
  "rcolorbrewer" = "RColorBrewer",
  "viridislite" = "viridisLite",
  "matrixstats" = "matrixStats",
  "matrix" = "Matrix",
  "hmisc" = "Hmisc",
  "seurat" = "Seurat",
  "biomart" = "biomaRt",
  "regioner" = "regioneR",
  "biovizbase" = "biovizBase",
  "biocmanager" = "BiocManager"
)

# packages.R names, keyed by their lowercase form, for case-insensitive matching
r_pkgs <- c(cran_pkgs, bioc_pkgs, names(github_pkgs))
r_lookup <- setNames(r_pkgs, tolower(r_pkgs))

# conda deps that aren't R packages
non_r <- c("r-base", "quarto", "bedtools", "wget")

toml <- readLines("pixi.toml", warn = FALSE)
# dependency lines look like `r-ggplot2 = "*"` or `"bioconductor-go.db" = ">=3.22.0,<4"`
dep_lines <- grep('^\\s*"?[a-z0-9._-]+"?\\s*=\\s*"', toml, value = TRUE)
conda_names <- gsub('^\\s*"?([a-z0-9._-]+)"?\\s*=.*$', "\\1", dep_lines)
conda_names <- setdiff(conda_names, c(non_r, "name", "description"))
conda_names <- grep("^(r-|bioconductor-)", conda_names, value = TRUE)

# strip the prefix, then recover the R capitalization
conda_stems <- sub("^(r-|bioconductor-)", "", conda_names)
conda_as_r <- ifelse(
  conda_stems %in% names(irregular),
  irregular[conda_stems],
  ifelse(
    conda_stems %in% names(r_lookup),
    r_lookup[conda_stems],
    conda_stems
  )
)

only_conda <- setdiff(conda_as_r, r_pkgs)
only_r <- setdiff(r_pkgs, conda_as_r)

cat(sprintf(
  "pixi.toml: %d R packages -- scripts/packages.R: %d packages\n",
  length(conda_as_r),
  length(r_pkgs)
))

if (length(only_conda) > 0) {
  cat("\nIn pixi.toml but not scripts/packages.R:\n")
  cat(paste(" -", sort(only_conda), collapse = "\n"), "\n")
}

if (length(only_r) > 0) {
  cat("\nIn scripts/packages.R but not pixi.toml (installed by fallback):\n")
  cat(paste(" -", sort(only_r), collapse = "\n"), "\n")
}

if (length(only_conda) == 0) {
  cat("\nEvery conda R package is accounted for in the manifest.\n")
} else {
  quit(status = 1)
}
