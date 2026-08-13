# Provision a Posit Cloud base project with every R package the course needs.
#
# Run once per year in a blank project, then save it as the class template:
#
#   source("https://raw.githubusercontent.com/rnabioco/molb-7950/main/scripts/setup-posit-cloud.R")
#
# Expect this to take a while and to pull down several GB.

# Bump this once a year. Pinning the snapshot freezes CRAN package versions for
# the whole semester, so an upstream release can't break an exercise mid-course.
# Bioconductor is pinned separately, by release, which BiocManager derives from
# the R version on the instance.
P3M_SNAPSHOT <- "2026-08-01"

P3M <- "https://packagemanager.posit.co"
REPO_RAW <- "https://raw.githubusercontent.com/rnabioco/molb-7950/main"

# Environment ------------------------------------------------------------

if (Sys.info()[["sysname"]] != "Linux") {
  warning(
    "This script targets Posit Cloud (Linux). ",
    "On a local machine use pixi instead -- see README.md.",
    call. = FALSE
  )
}

# Posit Cloud images move between Ubuntu releases; the P3M binary URL has to
# match or every package silently falls back to a slow source build.
ubuntu_codename <- function() {
  if (!file.exists("/etc/os-release")) {
    return("jammy")
  }
  os <- readLines("/etc/os-release", warn = FALSE)
  line <- grep("^VERSION_CODENAME=", os, value = TRUE)
  if (length(line) != 1) {
    return("jammy")
  }
  gsub("^VERSION_CODENAME=|\"", "", line)
}

codename <- ubuntu_codename()

options(
  # the __linux__/<codename> segment is what serves precompiled binaries; the
  # trailing date freezes versions. Bioconductor takes no such segment -- it is
  # pinned by release instead, which BiocManager derives from the R version.
  repos = c(
    CRAN = sprintf("%s/cran/__linux__/%s/%s", P3M, codename, P3M_SNAPSHOT)
  ),
  BioC_mirror = sprintf("%s/bioconductor", P3M),
  Ncpus = max(1L, parallel::detectCores())
)

cat(sprintf(
  "\n%s\nUbuntu:  %s\nCRAN:    %s\nLibrary: %s\n",
  R.version.string,
  codename,
  getOption("repos")[["CRAN"]],
  .libPaths()[1]
))

# Bootstrap --------------------------------------------------------------

# pak resolves CRAN, Bioconductor, and GitHub specs in one pass and picks the
# Bioconductor release matching this R version.
if (!requireNamespace("pak", quietly = TRUE)) {
  cat("\nBootstrapping pak\n")
  install.packages("pak")
}

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  cat("Bootstrapping BiocManager\n")
  install.packages("BiocManager")
}

cat(sprintf("Bioconductor: %s\n", as.character(BiocManager::version())))

# Manifest ---------------------------------------------------------------

# Works both from a clone and from a blank project where this file was sourced
# straight off GitHub.
load_shared <- function(file) {
  local_path <- file.path("scripts", file)
  if (file.exists(local_path)) {
    source(local_path)
  } else {
    source(sprintf("%s/scripts/%s", REPO_RAW, file))
  }
}

load_shared("pkg-utils.R")
load_shared("packages.R")

# Install ----------------------------------------------------------------

repo_pkgs <- c(cran_pkgs, bioc_pkgs)
all_pkgs <- c(repo_pkgs, names(github_pkgs))

cat(sprintf("\nManifest: %d packages\n\n", length(all_pkgs)))
present <- report_status(all_pkgs)

missing_pkgs <- all_pkgs[!present]
if (length(missing_pkgs) == 0) {
  cat("\nNothing to do -- all packages already installed.\n")
} else {
  cat(sprintf("\nInstalling %d packages\n", length(missing_pkgs)))

  missing_repo <- intersect(missing_pkgs, repo_pkgs)
  if (length(missing_repo) > 0) {
    specs <- ifelse(
      missing_repo %in% bioc_pkgs,
      paste0("bioc::", missing_repo),
      missing_repo
    )
    err <- tryCatch(
      {
        pak::pkg_install(specs, ask = FALSE)
        NULL
      },
      error = function(e) conditionMessage(e)
    )
    if (!is.null(err)) {
      cat(sprintf("  install error: %s\n", err))
    }
  }

  # separate call: an unauthenticated instance can hit the GitHub API rate
  # limit, and that shouldn't take the CRAN/Bioconductor install down with it
  missing_github <- intersect(missing_pkgs, names(github_pkgs))
  if (length(missing_github) > 0) {
    err <- tryCatch(
      {
        pak::pkg_install(unname(github_pkgs[missing_github]), ask = FALSE)
        NULL
      },
      error = function(e) conditionMessage(e)
    )
    if (!is.null(err)) {
      cat(sprintf("  GitHub install error: %s\n", err))
      cat("  If this is a rate limit, set GITHUB_PAT and re-run.\n")
    }
  }
}

# Verify -----------------------------------------------------------------

cat("\nVerifying\n")
final <- vapply(all_pkgs, is_installed, logical(1))
failed <- all_pkgs[!final]

for (pkg in missing_pkgs) {
  if (is_installed(pkg)) {
    status_line("installed", pkg, pkg_version(pkg))
  } else {
    status_line("FAILED", pkg)
  }
}

lib_bytes <- sum(
  file.size(list.files(.libPaths()[1], recursive = TRUE, full.names = TRUE)),
  na.rm = TRUE
)

cat(sprintf(
  "\nSummary: %d of %d present, %d failed -- library is %.1f GB\n",
  sum(final),
  length(all_pkgs),
  length(failed),
  lib_bytes / 1024^3
))

if (length(failed) > 0) {
  cat(paste(" -", failed, collapse = "\n"), "\n")
  quit(status = 1)
}

cat(
  "\nDone. Save this project as the class base project so assignments",
  "\ninherit the library.\n"
)
