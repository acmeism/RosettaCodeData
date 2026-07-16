library(gmp)

compose <- function(f, g) function(x) f(g(x))

onetwo <- function(nd) {
  lapply(nd:1 - 1, function(x) rep(1:2, each = 2^x)) |>
    do.call(paste0, args = _) |>
    grepv("(^2|1)$", x = _) |>
    as.bigz() |>
    Find(isprime, x = _)
}

abbr_ones <- function(s) {
  n_ones <- regexec("^1+", s)[[1]] |> attr("match.length")
  prefix <- ifelse(n_ones > 0, paste0("(", n_ones, " x 1) "), "")
  sub("^1+", prefix, s)
}

pretty_onetwo <- function(n, abbr = FALSE) {
  f <- if (abbr) compose(abbr_ones, onetwo) else onetwo
  sprintf("%i digits: %s", n, f(n))
}

sapply(1:20, pretty_onetwo) |> writeLines()
sapply(1:20, pretty_onetwo, abbr = TRUE) |> writeLines()
