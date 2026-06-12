library(stringr)

wordwheel <- function(s) {
  mid <- str_sub(s, 5, 5)
  rest <- str_c(str_sub(s, 1, 4), str_sub(s, 6, 9))

  wheelwords <- readLines("unixdict.txt") |>
    str_subset(str_glue("^[{rest}]*{mid}[{rest}]*$")) |>
    Filter(function(s) str_length(s) > 2, x = _)

  chars <- str_split_1(rest, "")
  maxs <- table(chars)
  check_occurrence <- function(x) function(s) {
    str_count(s, names(maxs)[x]) <= maxs[x]
  }
  for (i in seq_along(maxs)) {
    wheelwords <- Filter(check_occurrence(i), wheelwords)
  }
  cat(wheelwords)
}

wordwheel("ndeokgelw")
