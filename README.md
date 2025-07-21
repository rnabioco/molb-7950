# molb-7950

[![quarto build](https://github.com/rnabioco/molb-7950/actions/workflows/quarto.yaml/badge.svg)](https://github.com/rnabioco/molb-7950/actions/workflows/quarto.yaml)

Course materials for "MOLB 7950: Informatics and Statistics for Molecular Biology".

## Installing local packages

### Posit Cloud

Create a new template project and manually install packages.

### renv

While renv is a nice idea and is helpful for local development, in practice
it doesn't seem robust enough on Posit Cloud.

If you wanted to try using renv, clone the direction and then run `renv::activate()` and `renv::restore()`, which will install project
packages in a project-local library under `renv/`.

If you add new libraries to your content, run `renv::snapshot()`, follow
instructions to `renv::install()` if needed, and then be sure to commit the
`renv.lock` file.

You can also trying using `pak` for installation by setting
`RENV_CONFIG_PAK_ENABLED = TRUE` in the user's `.Renviron` file
(`usethis::edit_r_environ()`) to use pak installation,
which is a lot faster ([issue](https://github.com/rstudio/renv/issues/1210)).
In practice, pak with renv seems a bit flaky.

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
