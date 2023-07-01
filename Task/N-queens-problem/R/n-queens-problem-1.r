queens <- function(n) {
  a <- seq(n)
  u <- rep(T, 2 * n - 1)
  v <- rep(T, 2 * n - 1)
  m <- NULL
  aux <- function(i) {
    if (i > n) {
      m <<- cbind(m, a)
    } else {
      for (j in seq(i, n)) {
        k <- a[[j]]
        p <- i - k + n
        q <- i + k - 1
        if (u[[p]] && v[[q]]) {
          u[[p]] <<- v[[q]] <<- F
          a[[j]] <<- a[[i]]
          a[[i]] <<- k
          aux(i + 1)
          u[[p]] <<- v[[q]] <<- T
          a[[i]] <<- a[[j]]
          a[[j]] <<- k
        }
      }
    }
  }
  aux(1)
  m
}
