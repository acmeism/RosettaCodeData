bars <-  intToUtf8(seq(0x2581, 0x2588), multiple = T)  # ▁ ▂ ▃ ▄ ▅ ▆ ▇ █
n_chars <- length(bars)

sparkline <- function(numbers) {
  mn <- min(numbers)
  mx <- max(numbers)
  interval <- mx - mn

  bins <- sapply(
    numbers,
    function(i)
      bars[[1 + min(n_chars - 1, floor((i - mn) / interval * n_chars))]]
  )
  sparkline <- paste0(bins, collapse = "")

  return(sparkline)
}

sparkline(c(1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1))
sparkline(c(1.5, 0.5, 3.5, 2.5, 5.5, 4.5, 7.5, 6.5))
sparkline(c(0, 999, 4000, 4999, 7000, 7999))
sparkline(c(0, 0, 1, 1))
sparkline(c(0, 1, 19, 20))
