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

# Bump alongside P3M_SNAPSHOT. Posit Cloud grants no sudo, so this installs to
# ~/.local/bin rather than /usr/bin -- see install_pandoc() below.
PANDOC_VERSION <- "3.10.2"

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

# Pandoc -----------------------------------------------------------------

# RStudio and Quarto each bundle a pandoc, but neither is on PATH for terminal
# or Rscript use, and both are whatever version the image happens to ship. This
# installs a pinned pandoc the same way P3M_SNAPSHOT pins the packages.
#
# Posit Cloud grants no sudo (installing system dependencies "via sudo or
# otherwise" is unsupported), so /usr/bin is out of reach. ~/.local/bin lives in
# the persisted home directory, so it survives into projects made from this one.

append_once <- function(file, line) {
  existing <- if (file.exists(file)) {
    readLines(file, warn = FALSE)
  } else {
    character(0)
  }
  if (line %in% existing) {
    return(invisible(FALSE))
  }
  writeLines(c(existing, line), file)
  invisible(TRUE)
}

install_pandoc <- function(version) {
  bin_dir <- path.expand("~/.local/bin")

  # report whatever pandoc is already reachable, so a version surprise is visible
  for (src in c(
    PATH = unname(Sys.which("pandoc")),
    RStudio = Sys.getenv("RSTUDIO_PANDOC")
  )) {
    if (nzchar(src)) {
      status_line("found", basename(src), src)
    }
  }

  arch <- switch(
    system("uname -m", intern = TRUE)[1],
    "x86_64" = "amd64",
    "aarch64" = "arm64",
    NA_character_
  )
  if (is.na(arch)) {
    cat("  unrecognized architecture -- skipping pandoc\n")
    return(invisible(FALSE))
  }

  target <- file.path(bin_dir, "pandoc")
  if (file.exists(target)) {
    current <- tryCatch(
      system2(target, "--version", stdout = TRUE)[1],
      error = function(e) ""
    )
    if (grepl(version, current, fixed = TRUE)) {
      status_line("ok", "pandoc", sprintf("%s (%s)", version, target))
      return(invisible(TRUE))
    }
  }

  url <- sprintf(
    "https://github.com/jgm/pandoc/releases/download/%s/pandoc-%s-linux-%s.tar.gz",
    version,
    version,
    arch
  )
  cat(sprintf("  installing pandoc %s (%s)\n", version, arch))

  tmp <- tempfile(fileext = ".tar.gz")
  ok <- tryCatch(
    {
      utils::download.file(url, tmp, mode = "wb", quiet = TRUE)
      TRUE
    },
    error = function(e) {
      cat(sprintf("  download failed: %s\n", conditionMessage(e)))
      FALSE
    }
  )
  if (!ok) {
    return(invisible(FALSE))
  }

  ex <- tempfile()
  dir.create(ex, recursive = TRUE, showWarnings = FALSE)
  utils::untar(tmp, exdir = ex)

  dir.create(bin_dir, recursive = TRUE, showWarnings = FALSE)
  # the tarball also ships pandoc-server and pandoc-lua, ~156 MB each and unused
  # by the course -- copying only pandoc keeps 312 MB off the project's quota
  file.copy(
    file.path(ex, sprintf("pandoc-%s", version), "bin", "pandoc"),
    target,
    overwrite = TRUE
  )
  Sys.chmod(target, "0755")

  # put it on PATH for the terminal, for future R sessions, and for this one
  append_once("~/.bashrc", 'export PATH="$HOME/.local/bin:$PATH"')
  append_once("~/.Renviron", "PATH=${PATH}:${HOME}/.local/bin")
  Sys.setenv(PATH = paste(Sys.getenv("PATH"), bin_dir, sep = ":"))

  # confirm the binary actually runs and is the version asked for -- a failed
  # exec returns NA here, which would otherwise read as success
  installed <- tryCatch(
    suppressWarnings(system2(target, "--version", stdout = TRUE)[1]),
    error = function(e) NA_character_
  )
  if (!is.na(installed) && grepl(version, installed, fixed = TRUE)) {
    status_line("installed", "pandoc", sprintf("%s -- %s", installed, target))
    invisible(TRUE)
  } else {
    status_line(
      "FAILED",
      "pandoc",
      if (is.na(installed)) "binary would not run" else installed
    )
    invisible(FALSE)
  }
}

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

# defined above, but called here because it reports via pkg-utils.R helpers
cat("\nPandoc\n")
if (Sys.info()[["sysname"]] == "Linux") {
  pandoc_ok <- install_pandoc(PANDOC_VERSION)
  if (pandoc_ok) {
    # pak decides a system package is present by asking dpkg, so it will keep
    # reporting pandoc as a missing system requirement no matter what lands in
    # ~/.local/bin. Only `sudo apt install pandoc` would satisfy it, which this
    # platform doesn't allow. Harmless: rmarkdown::find_pandoc() searches
    # RSTUDIO_PANDOC, then PATH, and takes the *highest* version it finds.
    cat("  note: pak may still list pandoc as a missing system package.\n")
    cat("  It checks dpkg, not PATH -- expected here, and safe to ignore.\n")
  }
} else {
  pandoc_ok <- TRUE
  cat("  not Linux -- skipping\n")
}

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

if (!pandoc_ok) {
  cat(" - pandoc\n")
}

if (length(failed) > 0 || !pandoc_ok) {
  if (length(failed) > 0) {
    cat(paste(" -", failed, collapse = "\n"), "\n")
  }
  quit(status = 1)
}

cat(
  "\nDone. Restart R (Session > Restart R) so the PATH set in ~/.Renviron",
  "\ntakes effect, then confirm pandoc with:",
  "\n  Sys.which(\"pandoc\")",
  "\n  rmarkdown::find_pandoc()",
  "\n\nThen save this project as the class base project so assignments",
  "\ninherit the library.\n"
)
