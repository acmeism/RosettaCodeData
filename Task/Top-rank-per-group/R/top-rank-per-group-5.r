library(dplyr)
dfr %>%
  group_by(Department) %>%
  top_n(2, Salary)
