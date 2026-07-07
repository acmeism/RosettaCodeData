gosper <- function(.x) {
  .c <- bitwAnd(.x, -.x)
  .r <- .x + .c
  ((bitwXor(.r, .x) |> bitwShiftR(2L)) / .c) |> bitwOr(.r)
}

gosper_list <- function(n) function(x) {
  Reduce(
    function(x, f) f(x),
    rep(list(gosper), n),
    init = x,
    accumulate = TRUE
  ) |> paste0(c(":", rep("", n)), collapse = " ")
}

sapply(c(1, 3, 7, 15), gosper_list(10)) |> writeLines()
