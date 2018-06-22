library(tidyverse)
library(rvest)

task_html= read_html("http://rosettacode.org/wiki/Knapsack_problem/Bounded")
task_table= html_nodes(html, "table")[[1]] %>%
  html_table(table, header= T, trim= T) %>%
  set_names(c("items", "weight", "value", "pieces")) %>%
  filter(items != "knapsack") %>%
  mutate(weight= as.numeric(weight),
         value= as.numeric(value),
         pieces= as.numeric(pieces))
