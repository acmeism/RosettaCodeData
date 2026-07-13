library(gmp)

truncate_digits <- function(n, dmin, dmax, direction) {
  switch(
    direction,
    "left" = n %% (10^(dmin:dmax)),
    "right" = n %/% (10^(dmax:dmin - 1))
  )
}

is_trunc_prime <- function(direction, dmax) function(n) {
  if (grepl("0", n)) return(FALSE)
  truncate_digits(n, 1, dmax, direction) |>
    Filter(`+`, x = _) |>
    isprime() |>
    all()
}

c("left", "right") |> sapply(
  function(s) paste0(
      "The largest ", s, "-truncatable prime below a million is ",
      Find(is_trunc_prime(s, 6), 1:1e6 - 1, right = TRUE)
  )
) |> writeLines()
