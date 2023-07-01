Lah_numbers <- function(n, k, type = "unsigned") {

    if (n == k)
      return(1)

    if (n == 0 | k == 0)
      return(0)

    if (k == 1)
      return(factorial(n))

    if (k > n)
      return(NA)

    if (type == "unsigned")
      return((factorial(n) * factorial(n - 1)) / (factorial(k) * factorial(k - 1)) / factorial(n - k))

    if (type == "signed")
      return(-1 ** n * (factorial(n) * factorial(n - 1)) / (factorial(k) * factorial(k - 1)) / factorial(n - k))
  }

#demo
Table <- matrix(0 , 13, 13, dimnames = list(0:12, 0:12))

for (n in 0:12) {
  for (k in 0:12) {
    Table[n + 1, k + 1] <- Lah_numbers(n, k, type = "unsigned")
  }
}

Table
