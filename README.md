# molb-7950

Materials for "MOLB 7950: Informatics and Statistics for Molecular Biology".

## Installing local packages

After cloning this repository, set `RENV_CONFIG_PAK_ENABLED = TRUE` in the user's `.Renviron` file to use pak
installation, which is a lot faster ([issue](https://github.com/rstudio/renv/issues/1210)).

Then, run `renv::activate()` and `renv::restore()`, which will install  project packages locally.

If you add new libraries to your content, run `renv::snapshot()`, follow instructions to `renv::install()` if needed, and then be sure to commit the `renv.lock` file.

## Syllabus updates

1.  Edit the "Syllabus" sheet on the [Google
    Sheet](https://docs.google.com/spreadsheets/d/1MSu1YZdKk7LK9-m7EjzoMWggwlsEJ7dC1aiax85uvrE/edit#gid=1069962431).
    Contact Jay if you need access.
2.  Run `data-raw/syllabus.R`. You may be prompted to authenticate (one
    time). The writes a new `data/syllabus.tsv` file.
3.  Re-render the page (`quarto render index.qmd`) and check formatting.
4.  Commit and push to GitHub.

### Acknowledgements

This work borrows and modifies
https://github.com/mine-cetinkaya-rundel/quarto-sdss
