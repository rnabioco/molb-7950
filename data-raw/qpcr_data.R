# get data for class 3
library(tidyverse)
library(here)

sample <- c("wt", "mut")
gene <- c("IFN", "ACTIN")
time <- c(0, 12, 24, 48)
rt <- c("+", "-") # reverse transcriptase added?
rep <- 1:3

set.seed(42)
sample_data <- crossing(sample, time, gene, rep, rt)

plus_rts <- filter(sample_data, rt == "+")

t0 <- filter(plus_rts, time == 0) %>%
  rowwise() %>%
  mutate(exp = sample(5:15, 1))
t12 <- filter(plus_rts, time == 12) %>%
  rowwise() %>%
  mutate(exp = sample(45:55, 1))
t24 <- filter(plus_rts, time == 24) %>%
  rowwise() %>%
  mutate(exp = sample(95:100, 1))
t48 <- filter(plus_rts, time == 48) %>%
  rowwise() %>%
  mutate(exp = sample(350:600, 1))

plus_rts <- bind_rows(t0, t12, t24, t48)

# add multiplier for genes
ifns_wt <- filter(plus_rts, gene == "IFN" & sample == "wt") %>% mutate(exp = exp * 1.5)
ifns_mut <- filter(plus_rts, gene == "IFN" & sample == "mut") %>% mutate(exp = exp * 02)
actins <- filter(plus_rts, gene == "ACTIN") %>% mutate(exp = exp * 0.2)
plus_rts <- bind_rows(ifns_wt, ifns_mut, actins)

minus_rts <- filter(sample_data, rt == "-") %>% mutate(exp = 0)

sample_data <- bind_rows(plus_rts, minus_rts) %>% arrange(sample, time, gene, rep)

qpcr_names <- sample_data %>%
  unite(name, sample, time, gene, rt, rep, sep = "_") %>%
  pluck("name") %>%
  matrix(nrow = 8, ncol = 12) %>%
  as_tibble() %>%
  set_names(nm = 1:12) %>%
  mutate(row = toupper(letters[1:8])) %>%
  select(row, everything())

qpcr_data <- sample_data %>%
  pluck("exp") %>%
  matrix(nrow = 8, ncol = 12) %>%
  as_tibble() %>%
  set_names(nm = 1:12) %>%
  mutate(row = toupper(letters[1:8])) %>%
  select(row, everything())

write_tsv(qpcr_names, here("data/qpcr_names.tsv.gz"))
write_tsv(qpcr_data, here("data/qpcr_data.tsv.gz"))
