# rank choice voting for plot competition
# http://insights.emmanuel.edu/topics/academics/the-mathematics-of-ranked-choice-voting

library(googlesheets4)
library(here)
library(readr)
library(janitor)

ss <- "https://docs.google.com/spreadsheets/d/1MSu1YZdKk7LK9-m7EjzoMWggwlsEJ7dC1aiax85uvrE/edit#gid=1069962431"

vote_tbl <- read_sheet(ss, sheet = "Form Responses 4") |>
  clean_names() |>
  select(-timestamp) |>
  pivot_longer(-your_student_id, names_to = "plot", values_to = "rank") |>
  mutate(plot= str_replace(plot, 'top_3_selections_ranked_plot_', '')) |>
  drop_na() |>
  select(-your_student_id) |>
  count(plot, rank, sort = TRUE) |>
  pivot_wider(names_from = "rank", values_from = "n") |>
  rename(plot = plot, first = `1st`, second = `2nd`, third = `3rd`) |>
  select(plot, first, second, third) |>
  rowwise() |>
  mutate(score_sum = sum(3 * first, 2 * second, third, na.rm = TRUE)) |>
  arrange(-score_sum)


