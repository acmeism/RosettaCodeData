library(gmp)  # For handling large integers and modular arithmetic

# Legendre symbol: a^((p-1)/2) mod p
legendre <- function(a, p) {
  a <- as.bigz(a)
  p <- as.bigz(p)
  e <- div.bigz(sub.bigz(p, 1), 2)
  result <- powm(a, e, p)
  return(result)
}

# Tonelli-Shanks algorithm to find square root of n mod p
tonelli <- function(n, p) {
  n <- as.bigz(n)
  p <- as.bigz(p)

  # Check that n is a quadratic residue
  leg <- legendre(n, p)
  if (!identical(as.character(leg), "1")) {
    stop("not a square (mod p)")
  }

  q <- sub.bigz(p, 1)
  s <- 0
  while (mod.bigz(q, 2) == 0) {
    q <- div.bigz(q, 2)
    s <- s + 1
  }

  if (s == 1) {
    e <- div.bigz(add.bigz(p, 1), 4)
    return(powm(n, e, p))
  }

  z <- as.bigz(2)
  p_minus_1 <- sub.bigz(p, 1)
  while (z < p) {
    if (identical(as.character(legendre(z, p)), as.character(p_minus_1))) {
      break
    }
    z <- add.bigz(z, 1)
  }

  c <- powm(z, q, p)
  r <- powm(n, div.bigz(add.bigz(q, 1), 2), p)
  t <- powm(n, q, p)
  m <- s

  one <- as.bigz(1)
  two <- as.bigz(2)

  while (!identical(mod.bigz(sub.bigz(t, one), p), as.bigz(0))) {
    t2 <- mod.bigz(mul.bigz(t, t), p)
    i <- 1
    while (i < m) {
      if (identical(mod.bigz(sub.bigz(t2, one), p), as.bigz(0))) {
        break
      }
      t2 <- mod.bigz(mul.bigz(t2, t2), p)
      i <- i + 1
    }

    b_exp <- pow.bigz(two, m - i - 1)
    b <- powm(c, b_exp, p)
    r <- mod.bigz(mul.bigz(r, b), p)
    c <- mod.bigz(mul.bigz(b, b), p)
    t <- mod.bigz(mul.bigz(t, c), p)
    m <- i
  }

  return(r)
}

# Test cases
ttest <- list(
  c("10", "13"),
  c("56", "101"),
  c("1030", "10009"),
  c("44402", "100049"),
  c("665820697", "1000000009"),
  c("881398088036", "1000000000039"),
  c("41660815127637347468140745042827704103445750172002", "100000000000000000000000000000000000000000000000577")
)

for (case in ttest) {
  n <- as.bigz(case[1])
  p <- as.bigz(case[2])
  r <- tonelli(n, p)
  check <- mod.bigz(sub.bigz(mul.bigz(r, r), n), p)

  # Verify the result
  if (!identical(as.character(check), "0")) {
    stop("Verification failed")
  }

  cat("n =", as.character(n), "p =", as.character(p), "\n")
  cat("\troots :", as.character(r), as.character(sub.bigz(p, r)), "\n")
}
