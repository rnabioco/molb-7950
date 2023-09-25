# fix up bioconductor sources in renv.lock
#
# for some reason, some Bioconductor packages end up with Source: "Repository"
# and an undefined "Repository" field.
# 
# this just identifies those packages, sets Source: "Bioconductor", and then
# re-writes the lock file

library(jsonlite)
library(tidyverse)
library(renv)

wrong_source <- function(x) {
  x$Source == "Repository" && is.null(x$Repository)
}
fix_source <- function(x) {
  x$Source <- "Bioconductor"
  x
}

renv_json <- jsonlite::read_json("renv.lock")
pkgs <- renv_json$Packages

pkgs_fix <-
  purrr::map_lgl(
    pkgs,
    ~ wrong_source(.x)
  ) |> 
  which() |>
  purrr::map_at(
    .x = pkgs,
    .at = _,
    .f = fix_source
  )

renv_json$Packages <- pkgs_fix
renv:::renv_json_write(renv_json, file = "renv.lock")
