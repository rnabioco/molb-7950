# Verify all required packages are loadable.
# Run with: pixi run check-env

source("scripts/packages.R")

required_packages <- c(cran_pkgs, bioc_pkgs, names(github_pkgs))

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
