duration <- function(t){
  max_units <- c("sec"=60, "min"=60, "hr"=24, "d"=7)
  times <- numeric(4)
  for(i in 1:4){
    times[i] <- t%%max_units[i]
    t <- t%/%max_units[i]
  }
  times <- c(times, t)
  names(times) <- c(names(max_units), "wk")
  times <- rev(Filter(`+`, times))
  cat(paste(times, names(times)), sep=", ")
  cat("\n")
}

lapply(c(7259, 86400, 6000000), duration) |> invisible()
