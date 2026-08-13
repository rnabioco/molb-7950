# molb-7950

[![quarto build](https://github.com/rnabioco/molb-7950/actions/workflows/quarto.yaml/badge.svg)](https://github.com/rnabioco/molb-7950/actions/workflows/quarto.yaml)

Course materials for "MOLB 7950: Informatics and Statistics for Molecular Biology".

## Installing local packages

### pixi

Clone the repo, install [pixi](https://pixi.sh), then:

```bash
pixi install
pixi run install-pak-deps
```

This sets up R, Quarto, bioinformatics CLI tools, and all R packages. Packages
not available on conda-forge/bioconda are installed via `pak` (see
`scripts/install-pak-deps.R`).

Run `pixi run check-pak-deps` to report which of those packages are already
installed without installing anything.

### Adding a package

`scripts/packages.R` is the single source of truth for R packages, and every
install/verify script reads from it. To add a package:

1. Add the R name to `scripts/packages.R` (`cran_pkgs`, `bioc_pkgs`, or `github_pkgs`).
2. Add the conda name to `pixi.toml` if it's on conda-forge/bioconda, then commit `pixi.lock`.

Run `pixi run check-manifest` to confirm the two lists agree — CI fails if they
drift.

### Posit Cloud

Set up once a year. In a **blank** Posit Cloud project, run this in the console:

```r
source("https://raw.githubusercontent.com/rnabioco/molb-7950/main/scripts/setup-posit-cloud.R")
```

This pins CRAN to a dated Posit Package Manager snapshot so package versions stay
frozen for the semester, then installs the whole manifest. Expect a long first run
and several GB — `BSgenome.Hsapiens.UCSC.hg19` alone is ~700 MB, so check the
project's disk quota. The script prints the final library size and exits non-zero
if anything failed to install.

It also installs a pinned pandoc (~156 MB) into `~/.local/bin` and puts that
directory on `PATH` via `~/.bashrc` and `~/.Renviron`. Posit Cloud grants no
sudo, so a real system install into `/usr/bin` isn't possible; RStudio and Quarto
do each bundle a pandoc, but neither is on `PATH` for terminal or `Rscript` use
and the version is whatever the image happens to ship.

**Give the project enough RAM.** Everything should arrive precompiled, but if a
package does build from source, compiling it can take more than 1 GB and the OOM
killer will stop it with `Killed signal terminated program cc1plus`. The script
prints the detected RAM and scales parallel jobs to match; raise the project's
RAM in Posit Cloud if you hit this.

**Restart R afterwards** — `~/.Renviron` is only read at startup, so the `PATH`
entry doesn't apply to the session that ran the script. Then check with
`Sys.which("pandoc")` and `rmarkdown::find_pandoc()`.

`pak` will still report pandoc as a missing system package. It asks dpkg what's
installed, so it can't see `~/.local/bin`, and only `sudo apt install pandoc`
would satisfy it. Ignore it — `rmarkdown::find_pandoc()` searches
`RSTUDIO_PANDOC` and then `PATH`, taking the highest version it finds.

When it finishes, save the project as the class base project so assignments
inherit the library.

Bump `P3M_SNAPSHOT` and `PANDOC_VERSION` at the top of
`scripts/setup-posit-cloud.R` each year to pick up newer versions.

## Previewing content

Use `quarto render` or `quarto preview` locally to inspect content prior to
commit / push. A Github Action builds the site automatically unless you include
`[ci skip]` in the commit message.

After a significant update (i.e., uploading a lot of class material), you should
`quarto render` the entire site, and then commit & push the contents of the `_freeze` directory,
which will enable rendering of only changed materials relative to that build.

## File structure

Pages should be named based on the syllabus table, e.g., `class-01.qmd`.

The qmd files you want rendered as slides go in `slides/`, `exercises/`, `problem-sets/`, and `problem-set-keys/`

Each of these will be linked in the table on the front page.

If you want to suppress quarto rendering of a file, prefix the filename with an underscore like `_class-01.qmd`.

## Syllabus updates

1.  Edit the "Syllabus" sheet on the [Google
    Sheet](https://docs.google.com/spreadsheets/d/1MSu1YZdKk7LK9-m7EjzoMWggwlsEJ7dC1aiax85uvrE/edit#gid=1069962431).
    Contact Jay if you need access.
2.  Run `data-raw/syllabus.R`. You may be prompted to authenticate (one
    time). The writes a new `data/syllabus.tsv` file.
3.  Re-render the page (`quarto render index.qmd`) and check formatting.
4.  Commit and push to GitHub.

## Additional, external content

- Problem sets and keys live here: https://github.com/rnabioco/molb-7950-problem-sets

- Large data sets, mainly single-cell problem sets, live here (so we don't bloat this repo): https://github.com/rnabioco/molb-7950-data/

## AI tooling

Setup the project using the suggestions here: https://www.simonpcouch.com/blog/2025-07-17-claude-code-2/

### Acknowledgements

This work borrows from and modifies:
https://github.com/mine-cetinkaya-rundel/quarto-sdss
