isvile <- function(n) log2(bitwAnd(n, -n)) %% 2 == 0

firstn <- function(lim, pred, name) {
  cat("First", lim, name, "numbers:\n")
  count <- 0
  n <- 1
  while (count < lim) {
    if (pred(n)) {
      cat(n, "")
      count <- count + 1
    }
    n <- n + 1
  }
}

firstn(25, isvile, "vile")
firstn(25, Negate(isvile), "dopey")

predcount <- function(pred) function(lim) sum(pred(1:lim))

sapply(
  c(`+`, predcount(isvile), predcount(Negate(isvile))),
  function(f) sapply(2^(1:10), f)
) |> `colnames<-`(c("upto", "viles", "dopeys"))
