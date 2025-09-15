library(googlesheets4)
library(here)
library(readr)

# contact jay if you need access to the class sheet below
ss <- "https://docs.google.com/spreadsheets/d/1eqB6kuWEExhSotdtF5uDU8nKpNlME2BQH5dw1EhAlH8/edit?gid=1069962431#gid=1069962431"

read_sheet(
  ss,
  sheet = "Syllabus"
) |>
  write_tsv(here("data/syllabus.tsv"))
