source("common.R")

library(tidyverse)
library(here)

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
    go_molecular_function = MF,
    go_biological_process = BP
  ) |>
  distinct()

brauer_gene_exp_wide <-
  select(
    brauer_gene_exp_raw,
    -name,
    -number, -GID, -YORF,
    -GWEIGHT, -BP, -MF
  )

brauer_gene_exp_tidy <-
  pivot_longer(
    brauer_gene_exp_wide,
    -systematic_name,
    names_to = "nutrient_rate",
    values_to = "exp"
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
    nutrient,
    everything(),
    -nutrient_abbr
    ) |>
  mutate(across(c(rate, nutrient), as_factor)) |>
  arrange(desc(systematic_name), nutrient, rate)

write_tsv(brauer_gene_exp, file = here("data", "brauer_gene_exp_tidy.tsv.gz"))
write_tsv(brauer_gene_exp, file = here("data", "brauer_gene_exp_wide.tsv.gz"))
write_tsv(brauer_gene_exp_raw, file = here("data", "brauer_gene_exp_raw.tsv.gz"))
write_tsv(yeast_go_terms, file = here("data", "yeast_go_terms.tsv.gz"))

url <- 'http://sgd-archive.yeastgenome.org/curation/calculated_protein_info/archive/protein_properties.tab.20210422.gz'
yeast_prot_prop <- read_tsv(url)
write_tsv(yeast_prot_prop, here("data/yeast_prot_prop.tsv.gz"))

# save_data(brauer_gene_exp_raw)
# save_data(brauer_gene_exp)
# save_data(yeast_go_terms)
