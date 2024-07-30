# get data for problem set 9
library(tidyverse)
library(here)

gt <- c("wt", "TF-mutant", "RL-mutant")
gene <- c("IFN-beta", "GAPDH")
time <- c(0, 4, 8, 12, 24, 48)
rep_bio <- 1:3
rep_tech <- 1:3

set.seed(42)
sample_data <- crossing(gt, time, gene, rep_bio, rep_tech)

sample_data <-
  sample_data |>
  mutate(exp = time + 1) |>
  rowwise() |>
  mutate(
    exp = case_when(
      gene == "GAPDH" ~ exp * runif(1),
      gene == "IFN-beta" ~ exp * runif(1, 4, 6)
    )
  ) |>
  mutate(
    exp = case_when(
      gt == "wt" ~ exp * 0.2,
      gt == "TF-mutant" ~ exp * runif(1, 2, 2.5),
      .default = exp
    )
  ) |>
  group_by(gt, time, gene, rep_bio) |>
  mutate(
    exp = exp * runif(1, 0.6, 0.8)
  )

# 384 well plate
qpcr_names <- sample_data |>
  unite(sample, gt, time, gene, rep_bio, rep_tech, sep = "_") |>
  pull("sample") |>
  matrix(nrow = 18, ncol = 18) |>
  as_tibble() |>
  set_names(nm = 1:18) |>
  mutate(row = toupper(letters[1:18])) |>
  select(row, everything())

qpcr_data <- sample_data |>
  pull("exp") |>
  matrix(nrow = 18, ncol = 18) |>
  as_tibble() |>
  set_names(nm = 1:18) |>
  mutate(row = toupper(letters[1:18])) |>
  select(row, everything())

write_tsv(qpcr_names, here("data/qpcr_names_ps.tsv.gz"))
write_tsv(qpcr_data, here("data/qpcr_data_ps.tsv.gz"))
