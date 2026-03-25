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

To add a new package, either add it to `pixi.toml` (if on conda-forge/bioconda)
or to `scripts/install-pak-deps.R` (if not), then commit `pixi.lock`.

### Posit Cloud

Create a new template project and manually install packages with `pak`:

```r
install.packages("pak")
pak::pak("tidyverse")
```

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
