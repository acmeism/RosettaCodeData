digsum <- function(n, nd) sum((n %/% (10^(1:nd - 1))) %% 10)

unluckies <- function(nd) {
 lapply(nd:1 - 1, function(x) rep(c(2, 3, 5, 7), each = 4^x)) |>
    do.call(paste0, args = _) |>
    as.numeric() |>
    Filter(function(n) digsum(n, nd) == 13, x = _)
}

lapply(3:6, unluckies) |> unlist() |> cat()
