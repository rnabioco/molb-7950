# Install R packages not available on conda-forge/bioconda.
# Run with: pixi run install-pak-deps
# Report status without installing: pixi run check-pak-deps

options(
  repos = c(
    CRAN = "https://cran.rstudio.com"
  )
)

args <- commandArgs(trailingOnly = TRUE)
check_only <- any(args %in% c("--check", "--dry-run"))

# Status helpers ---------------------------------------------------------

# some packages print on load, so swallow their output to keep the report clean
is_installed <- function(pkg) {
  ok <- FALSE
  suppressMessages(suppressWarnings(
    utils::capture.output(ok <- requireNamespace(pkg, quietly = TRUE))
  ))
  ok
}

pkg_version <- function(pkg) {
  tryCatch(
    as.character(utils::packageVersion(pkg)),
    error = function(e) NA_character_
  )
}

status_line <- function(mark, pkg, note = "") {
  cat(sprintf("  %-9s %-42s %s\n", mark, pkg, note))
}

# Bootstrap installers ---------------------------------------------------

if (!is_installed("BiocManager")) {
  cat("Bootstrapping BiocManager\n")
  install.packages("BiocManager")
}

if (!is_installed("remotes")) {
  cat("Bootstrapping remotes\n")
  install.packages("remotes")
}

# Package manifest -------------------------------------------------------

groups <- list(
  # GitHub-only packages
  # cpp11bigwig arrives as a valr dependency, so it is not listed here.
  list(
    name = "GitHub",
    pkgs = c(emo = "hadley/emo"),
    install = function(pkgs) {
      for (repo in pkgs) remotes::install_github(repo, upgrade = "never")
    }
  ),
  # Bioconductor packages missing osx-arm64 builds (linux-64 gets them from
  # conda), plus CRAN packages where the conda-forge version is too old.
  list(
    name = "Bioconductor / CRAN",
    pkgs = c(
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
      #  "rGADEM",
      "seqLogo",
      "valr"
    ),
    install = function(pkgs) {
      BiocManager::install(pkgs, update = FALSE, ask = FALSE)
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

  present <- vapply(names, is_installed, logical(1))
  for (i in seq_along(names)) {
    if (present[i]) {
      status_line("ok", names[i], pkg_version(names[i]))
    } else {
      status_line("missing", names[i])
    }
  }
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
