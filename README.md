# molb-7950

Course materials for "MOLB 7950: Informatics and Statistics for Molecular Biology".

## Installing local packages

After cloning this repository, set `RENV_CONFIG_PAK_ENABLED = TRUE` in the
user's `.Renviron` file (`usethis::edit_r_environ()`) to use pak installation,
which is a lot faster ([issue](https://github.com/rstudio/renv/issues/1210)).

Then, run `renv::activate()` and `renv::restore()`, which will install project
packages in a project-local library under `renv/`.

If you add new libraries to your content, run `renv::snapshot()`, follow
instructions to `renv::install()` if needed, and then be sure to commit the
`renv.lock` file.

## Previewing content

Use `quarto render` or `quarto preview` locally to inspect content prior to
commit / push. A Github Action builds the site automatically unless you include
`[ci skip]` in the commit message.

## File structure

Pages should be named based on the syllabus table, e.g., `class-01.qmd`.

* qmd you want rendered as webpages go in `pages/`
* qmd you want rendered as slides go in `slides/`

There are also directories for `exercises/`, `problem-sets/`, and `problem-set-keys/`.

Each of these will be linked in the table on the front page.

If you want to suppress quarto rendering of a file, use an underscore prefix like `_class-01.qmd`.

## Syllabus updates

1.  Edit the "Syllabus" sheet on the [Google
    Sheet](https://docs.google.com/spreadsheets/d/1MSu1YZdKk7LK9-m7EjzoMWggwlsEJ7dC1aiax85uvrE/edit#gid=1069962431).
    Contact Jay if you need access.
2.  Run `data-raw/syllabus.R`. You may be prompted to authenticate (one
    time). The writes a new `data/syllabus.tsv` file.
3.  Re-render the page (`quarto render index.qmd`) and check formatting.
4.  Commit and push to GitHub.

### Acknowledgements

This work borrows fromand modifies:
https://github.com/mine-cetinkaya-rundel/quarto-sdss
