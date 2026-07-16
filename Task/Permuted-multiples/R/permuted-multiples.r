digits <- function(n, nd) (n %/% (10^(1:nd - 1))) %% 10

samedigits <- function(n, nd) {
  digs <- sort(digits(n, nd))
  for (i in 2:6) {
    if (!identical(sort(digits(n*i, nd)), digs)) return(FALSE)
  }
  return(TRUE)
}

main <- function() {
  options(scipen = 7)
  nd <- 2
  repeat {
    begin <- 10^nd
    for (n in begin:((begin*10) %/% 6)) {
      if (samedigits(n, nd + 1)) {
        cat("Found n = ", n, ":\n", sep = "")
        paste0(n, "*", 2:6, " = ", n*2:6) |> writeLines()
        return(invisible())
      }
    }
    cat("Found nothing below", begin*10, "\n")
    nd <- nd + 1
  }
}

main()
