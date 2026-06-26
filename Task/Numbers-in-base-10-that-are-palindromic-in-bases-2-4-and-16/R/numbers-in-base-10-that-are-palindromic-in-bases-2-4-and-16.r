library(stringi)

tobase <- function(
    n, base, digits = seq_len(base)-1, limit = ceiling(log(n, base))
) {
  limit:0 |>
    lapply(function(x) rep(digits, each = base^x)) |>
    do.call(paste0, args = _) |>
    head(n) |>
    gsub("^0+", "", x = _)
}

Reduce(
  function(x, y) x & sapply(y, function(s) s == stri_reverse(s)),
  list(
    tobase(25000, 2),
    tobase(25000, 4),
    tobase(25000, 16, c(0:9, letters[1:6]))
  ),
  init = TRUE
) |>
  which() |>
  setNames(NULL) |>
  (function(v) v-1)() |>
  cat()
