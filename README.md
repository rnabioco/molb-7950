# molb-7950


Materials for "MOLB 7950: Informatics for Molecular Biology".

See <https://rnabioco.github.io/molb-7950> for the class page.

## Installing local packages

After cloning this repository, run `renv::restore()`, which will install 
project packages locally.

If you add new libraries to your content, run `renv::snapshot()` and be sure to commit the `renv.lock` file.

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
