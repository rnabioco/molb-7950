# Install any manifest package the conda environment didn't supply.
# Run with: pixi run install-pak-deps
# Report status without installing: pixi run check-pak-deps
#
# On linux-64 conda covers nearly everything, so this is usually a no-op. On
# osx-arm64 it fills in the Bioconductor packages that have no arm build, and
# on a bare machine it installs the whole manifest. The package list lives in
# scripts/packages.R.

options(
  repos = c(
    CRAN = "https://cran.rstudio.com"
  )
)

args <- commandArgs(trailingOnly = TRUE)
check_only <- any(args %in% c("--check", "--dry-run"))

source("scripts/pkg-utils.R")
source("scripts/packages.R")

# Bootstrap installers ---------------------------------------------------

if (!is_installed("BiocManager")) {
  cat("Bootstrapping BiocManager\n")
  install.packages("BiocManager")
}

if (!is_installed("remotes")) {
  cat("Bootstrapping remotes\n")
  install.packages("remotes")
}

# Install groups ---------------------------------------------------------

groups <- list(
  list(
    name = "CRAN",
    pkgs = cran_pkgs,
    install = function(pkgs) install.packages(pkgs)
  ),
  list(
    name = "Bioconductor",
    pkgs = bioc_pkgs,
    install = function(pkgs) {
      BiocManager::install(pkgs, update = FALSE, ask = FALSE)
    }
  ),
  list(
    name = "GitHub",
    pkgs = github_pkgs,
    install = function(pkgs) {
      for (repo in pkgs) {
        remotes::install_github(repo, upgrade = "never")
      }
    }
  )
)

# Report -> install -> verify --------------------------------------------

cat(sprintf(
  "\n%s -- library: %s\n",
  R.version.string,
  .libPaths()[1]
))

n_present <- 0L
n_installed <- 0L
failed <- character(0)

for (group in groups) {
  pkgs <- group$pkgs
  # named vectors (GitHub) key on the package name, not the install spec
  names <- if (is.null(names(pkgs))) pkgs else names(pkgs)

  cat(sprintf("\n%s\n", group$name))

  present <- report_status(names)
  n_present <- n_present + sum(present)

  missing_names <- names[!present]
  if (length(missing_names) == 0) {
    cat(sprintf(
      "  all %d package%s present\n",
      length(names),
      if (length(names) == 1) "" else "s"
    ))
    next
  }

  if (check_only) {
    cat(sprintf(
      "  would install %d package%s: %s\n",
      length(missing_names),
      if (length(missing_names) == 1) "" else "s",
      paste(missing_names, collapse = ", ")
    ))
    failed <- c(failed, missing_names)
    next
  }

  cat(sprintf(
    "  installing %d package%s: %s\n",
    length(missing_names),
    if (length(missing_names) == 1) "" else "s",
    paste(missing_names, collapse = ", ")
  ))

  err <- tryCatch(
    {
      group$install(pkgs[!present])
      NULL
    },
    error = function(e) conditionMessage(e)
  )
  if (!is.null(err)) {
    cat(sprintf("  install error: %s\n", err))
  }

  for (pkg in missing_names) {
    if (is_installed(pkg)) {
      status_line("installed", pkg, pkg_version(pkg))
      n_installed <- n_installed + 1L
    } else {
      status_line("FAILED", pkg)
      failed <- c(failed, pkg)
    }
  }
}

# Summary ----------------------------------------------------------------

if (check_only) {
  cat(sprintf(
    "\nSummary: %d already present, %d missing\n",
    n_present,
    length(failed)
  ))
} else {
  cat(sprintf(
    "\nSummary: %d already present, %d installed, %d failed\n",
    n_present,
    n_installed,
    length(failed)
  ))
}

if (length(failed) > 0) {
  cat(paste(" -", failed, collapse = "\n"), "\n")
  quit(status = 1)
}
