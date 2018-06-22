library(dplyr)
dfr %>%
  group_by(Department) %>%
  mutate(r=rank(-Salary)) %>%
  filter(r<3) %>%
  arrange(Department,-Salary)
