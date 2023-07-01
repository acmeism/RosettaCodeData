library(tidyverse)
library(lubridate)
# Make a pretty date function:
pretty_date = stamp_date("Thu, Jun 1, 2000")

# Gregorian calendar:
tibble(year = c(seq(400, 2100, 100), 2010:2020)) %>%
  arrange(year) %>%
  mutate(a = year %% 19,
         b = year %% 4,
         c = year %% 7,
         k = year %/% 100,
         p = (13 + 8 * k) %/% 25,
         q = k %/% 4,
         M = (15 - p + k - q) %% 30,
         N = (4 + k - q) %% 7,
         d = (19 * a + M) %% 30,
         e = (2 * b + 4 * c + 6 * d + N) %% 7,
         easter_mar = 22 + d + e,
         easter_apr = d + e - 9,
         easter_day = if_else(easter_mar <= 31, easter_mar, easter_apr),
         easter_day = case_when(
           d == 29 & e == 6 ~ 19,
           d == 28 & e == 6 & (11 * M + 11) %% 30 < 19 ~ 18,
           TRUE ~ easter_day),
         easter_day = sprintf("%02d", easter_day),
         easter_year = sprintf("%04d", year),
         easter_mon = if_else(easter_mar <= 31, "03", "04")) %>%
  unite("easter", easter_year, easter_mon, easter_day, sep = "-") %>%
  mutate(Easter = parse_date(easter, format = "%Y-%m-%e")) %>%
  select(Easter) %>%
  mutate(Ascension = Easter + 39,
         Pentecost = Ascension + 10,
         Trinity = Pentecost + 7,
         `Corpus Christi` = Trinity + 4,
         across(.fns = pretty_date))
