aux <- function(i, j, u) {
  k <- u[[i, j]]
  if (k < 0) {
    i
  } else {
    paste0("(", Recall(i, k, u), "*", Recall(i + k, j - k, u), ")")
  }
}

chain.mul <- function(a) {
  n <- length(a) - 1
  u <- matrix(0, n, n)
  v <- matrix(0, n, n)
  u[, 1] <- -1

  for (j in seq(2, n)) {
    for (i in seq(n - j + 1)) {
      v[[i, j]] <- Inf
      for (k in seq(j - 1)) {
        s <- v[[i, k]] + v[[i + k, j - k]] + a[[i]] * a[[i + k]] * a[[i + j]]
        if (s < v[[i, j]]) {
          u[[i, j]] <- k
          v[[i, j]] <- s
        }
      }
    }
  }

  list(cost = v[[1, n]], solution = aux(1, n, u))
}

chain.mul(c(5, 6, 3, 1))
# $cost
# [1] 48

# $solution
# [1] "(1*(2*3))"

chain.mul(c(1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2))
# $cost
# [1] 38120

# $solution
# [1] "((((((((1*2)*3)*4)*5)*6)*7)*(8*(9*10)))*(11*12))"

chain.mul(c(1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10))
# $cost
# [1] 1773740

# $solution
# [1] "(1*((((((2*3)*4)*(((5*6)*7)*8))*9)*10)*11))"
