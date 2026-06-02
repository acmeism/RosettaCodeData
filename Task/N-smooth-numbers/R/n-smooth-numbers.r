smallprimes <- c(2, 3, 5, 7, 11, 13, 17, 19, 23, 29)

nextpsmooth <- function(p) function(n) {
  nextn(n, Filter(function(x) x <= p, smallprimes))
}

psmoothlist <- function(p, n) {
  Reduce(function(x, f) 1 + f(x),
         rep(list(nextpsmooth(p)), n-1),
         init = 2,
         accumulate = TRUE)-1
}

printpsmooth <- function(a, b) function(p) {
  cat(p, "-smooth numbers from index ", a, " to ", b, " are:\n", sep = "")
  cat(tail(psmoothlist(p, b), ifelse(a == 1, b, 1-a)), "\n")
}

sapply(smallprimes, printpsmooth(1, 25)) |> invisible()
sapply(tail(smallprimes, -3), printpsmooth(3000, 3002)) |> invisible()
