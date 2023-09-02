source("common.R")

library(tidyverse)
library(usethis)

url <- "http://varianceexplained.org/files/Brauer2008_DataSet1.tds"

nutrient_abbrs <- tribble(
  ~ nutrient_abbr, ~ nutrient,
  "G", "Glucose",
  "L", "Leucine",
  "P", "Phosphate",
  "S", "Sulfate",
  "N", "Ammonia",
  "U", "Uracil"
)

brauer_gene_exp_raw <-
  read_delim(
    url,
    delim = "\t",
    show_col_types = FALSE) |>
  separate(
    NAME,
    c("name", "BP", "MF", "systematic_name", "number"),
    sep = "\\|\\|"
    ) |>
  mutate(
    across(name:number, trimws)
    ) |>
  mutate(
    name = na_if(name, "")
    )

yeast_go_terms <- 
  select(
    brauer_gene_exp_raw,
    systematic_name,
    common_name = name,
    molecular_function = MF,
    biological_process = BP
  ) |>
  distinct()

brauer_gene_exp <-
  select(
    brauer_gene_exp_raw,
    -name,
    -number, -GID, -YORF,
    -GWEIGHT, -BP, -MF
    ) |>
  pivot_longer(
    -systematic_name,
    names_to = "nutrient_rate",
    values_to = "exp_level"
    ) |>
  separate(
    nutrient_rate,
    into = c("nutrient_abbr", "rate"),
    sep = 1,
    convert = FALSE 
    ) |>
  filter(systematic_name != "") |>
  left_join(nutrient_abbrs, by = "nutrient_abbr") |>
  select(
    systematic_name,
    nutrient, everything(), -nutrient_abbr
    ) |>
  mutate(across(c(rate, nutrient), as_factor)) |>
  arrange(desc(systematic_name), nutrient, rate)

save_data(brauer_gene_exp_raw)
save_data(brauer_gene_exp)
save_data(yeast_go_terms)
