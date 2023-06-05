library(googlesheets4)
library(here)

# contact jay if you need access to the class sheet below
ss <- 'https://docs.google.com/spreadsheets/d/1MSu1YZdKk7LK9-m7EjzoMWggwlsEJ7dC1aiax85uvrE/edit#gid=1069962431'

sched_tbl <- read_sheet(ss, sheet = 'Syllabus') |>
  write_tsv(here('data/syllabus.tsv'))
  