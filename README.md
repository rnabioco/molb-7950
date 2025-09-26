# molb-7950

[![quarto build](https://github.com/rnabioco/molb-7950/actions/workflows/quarto.yaml/badge.svg)](https://github.com/rnabioco/molb-7950/actions/workflows/quarto.yaml)

Course materials for "MOLB 7950: Informatics and Statistics for Molecular Biology".

## Installing local packages

### Posit Cloud

Create a new template project and manually install packages.

### renv

Clone a fresh repo and then run `renv::activate()` and `renv::restore()`, which will install project
packages in a project-local library under `renv/`.

When you add new libraries to your content, run `renv::snapshot()`, follow
instructions to `renv::install()` if needed, and then be sure to commit the
`renv.lock` file.

It is sometimes help to do this when CRAN versions are updated nightly, causing
GHA builds to fail, as e.g. a Mac version might be available before Linux (ubuntu on GHA).
In these case, you can just install that most recent working version i.e. `renv::install("tidyverse@1.0.1")`.

I **do not** recommend using renv on Posit Cloud, it seems flakier there. Just make Project templates
and install packages individually. I recommend using pak there:

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
