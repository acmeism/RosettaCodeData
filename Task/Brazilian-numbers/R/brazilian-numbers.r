# Brazilian numbers

SameDigits <- function(n, b) {
  # Result: TRUE if n has same digits in the base b, FALSE otherwise
  nl <- n
  f <- nl %% b
  nl <- nl %/% b
  while (nl > 0) {
    if (nl %% b != f)
       return(FALSE)
    nl <- nl %/% b
  }
  return(TRUE)
}

IsBrazilian <- function(n) {
  if (n < 7)
    return(FALSE)
  else if (n %% 2 == 0 && n >= 8)
    return(TRUE)
  else {
    for (b in 2:(n - 2))
      if (SameDigits(n, b))
        return(TRUE)
    return(FALSE)
  }
}

IsPrime <- function(n) {
  if (n < 2)
    return(FALSE)
  else if (n %% 2 == 0)
    return(n == 2)
  else if (n %% 3 == 0)
    return(n == 3)
  else {
    d <- 5
    while (d * d <= n) {
      if (n %% d == 0)
        return(FALSE)
      else {
        d <- d + 2
        if (n %% d == 0)
          return(FALSE)
        else
          d <- d + 4
      }
    } # while
    return(TRUE)
  }
}

print("First 20 Brazilian numbers:")
c <- 0
n <- 7
result.list <- c()
while (c < 20) {
  if (IsBrazilian(n)) {
    result.list <- append(result.list, n)
    c <- c + 1
  }
  n <- n + 1
}
result.list
print("First 20 odd Brazilian numbers:")
c <- 0
n <- 7
result.list <- c()
while (c < 20) {
  if (IsBrazilian(n)) {
    result.list <- append(result.list, n)
    c <- c + 1
  }
  n <- n + 2
}
result.list
print("First 20 prime Brazilian numbers:")
c <- 0
n <- 7
result.list <- c()
while (c < 20) {
  if (IsBrazilian(n)) {
     result.list <- append(result.list, n)
     c <- c + 1
  }
  repeat {
    n <- n + 2
    if (IsPrime(n)) break
  }
}
result.list
