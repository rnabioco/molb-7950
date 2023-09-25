# fix up bioconductor sources in renv.lock
library(jsonlite)
library(tidyverse)
library(renv)

renv_json <- jsonlite::read_json("renv.lock")

wrong_source <- function(x) {
  x$Source == "Repository" && is.null(x$Repository)
}

fix_source <- function(x) {
  x$Source <- "Bioconductor"
  x
}

pkgs <- renv_json$Packages

fix_idx <- purrr::map_lgl(
  pkgs,
  ~ wrong_source(.x)
) |> which()

pkgs_fix <- purrr::map_at(pkgs, fix_idx, fix_source)

renv_json$Packages <- pkgs_fix

renv:::renv_json_write(renv_json, file = "renv.lock")
