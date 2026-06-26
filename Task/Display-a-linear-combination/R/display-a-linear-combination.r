library(stringr)

basisify <- function(v) {
  out <- ifelse(v == 0, "", str_glue("{v}*e({seq_along(v)})")) |>
    Filter(function(s) str_length(s) > 0, x = _)
  if(length(out) == 0) return("0")
  str_replace_all(out, fixed("1*"), "") |>
    str_flatten(collapse = " + ") |>
    str_replace_all(fixed("+ -"), "- ")
}

test_vectors <- list(
  c(1, 2, 3),
  c(0, 1, 2, 3),
  c(1, 0, 3, 4),
  c(1, 2, 0),
  c(0, 0, 0),
  0,
  c(1, 1, 1),
  c(-1, -1, -1),
  c(-1, -2, 0, -3),
  -1
)

writeLines(sapply(test_vectors, basisify))
