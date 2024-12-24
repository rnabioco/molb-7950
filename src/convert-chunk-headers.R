# convert chunk labels in all *.qmd files to quarto format

library(tidyverse)
library(here)
library(fs)
library(knitr)

files <- dir_ls(here(), recurse = TRUE, glob = "*.qmd")

purrr::map(
  files,
  convert_chunk_header,
  output = identity 
)
