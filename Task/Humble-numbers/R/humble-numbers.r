humble <- function(n) -1 + Reduce(
  function(x, f) 1 + f(x),
  rep(list(function(n) nextn(n, c(2, 3, 5, 7))), n-1),
  init = 2,
  accumulate = TRUE
)

cat(humble(50))

group_by_digits <- function(f, fname, lim) {
  f(lim) |>
    log10() |>
    floor() |>
    (function(x) rle(x)$lengths)() |>
    head(-1) |>
    (function(x) paste(
      "There are", x, fname, "numbers with", seq_along(x), "digit(s)"
    ))()
}

group_by_digits(humble, "humble", 5000) |> writeLines()
