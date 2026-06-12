# Schieber-Vishkin Algorithm Implementation in R
# Based on rosettacode.org/wiki/Schieber-Vishkin_algorithm

# Node structure for a triply linked tree
create_node <- function() {
  list(child = 0, sib = 0, parent = 0)
}

# Process the input array `a` of size `n` into a triply linked tree
# and return the vectors pi_, beta, alfa, tau, and lam
process <- function(n, a) {
  pi_ <- integer(n + 1)
  beta <- integer(n + 1)
  alfa <- integer(n + 1)
  tau <- integer(n + 1)
  lam <- integer(n + 1)

  # Create n+1 default Node objects
  nodes <- vector("list", n + 1)
  for (i in 1:(n + 1)) {
    nodes[[i]] <- create_node()
  }

  # Make triply linked tree
  t <- 0
  for (v in n:1) {
    u <- 0
    while (a[v + 1] > a[t + 1] || (a[v + 1] == a[t + 1] && v > t)) {
      u <- t
      t <- nodes[[t + 1]]$parent
    }

    if (u != 0) {
      nodes[[v + 1]]$sib <- nodes[[u + 1]]$sib
      nodes[[u + 1]]$sib <- 0
      nodes[[u + 1]]$parent <- v
      nodes[[v + 1]]$child <- u
    } else {
      nodes[[v + 1]]$sib <- nodes[[t + 1]]$child
    }

    nodes[[t + 1]]$child <- v
    nodes[[v + 1]]$parent <- t
    t <- v
  }

  # Begin first traversal
  p <- nodes[[1]]$child
  n_count <- 0
  lam[1] <- -1

  # First traversal function
  traversal <- function() {
    while (TRUE) {
      # s3: Compute beta in the easy case
      n_count <<- n_count + 1
      pi_[p + 1] <<- n_count
      tau[n_count + 1] <<- 0
      lam[n_count + 1] <<- 1 + lam[bitwShiftR(n_count, 1) + 1]

      if (nodes[[p + 1]]$child != 0) {
        p <<- nodes[[p + 1]]$child
        next # Continue to next iteration
      }

      beta[p + 1] <<- n_count
      break
    }

    # s4: Compute tau, bottom-up
    while (TRUE) {
      tau[beta[p + 1]] <<- nodes[[p + 1]]$parent

      if (nodes[[p + 1]]$sib != 0) {
        p <<- nodes[[p + 1]]$sib
        return(TRUE)
      }

      p <<- nodes[[p + 1]]$parent

      # Compute beta in the hard case
      if (p != 0) {
        h <- lam[bitwAnd(n_count, -pi_[p + 1]) + 1]
        beta[p + 1] <<- bitwShiftL(bitwOr(bitwShiftR(n_count, h), 1), h)
      } else {
        return(FALSE) # Exit traversal
      }
    }
  }

  # Perform first traversal
  while (traversal()) {}

  # Begin second traversal
  p <- nodes[[1]]$child
  lam[1] <- lam[n_count + 1]
  pi_[1] <- 0
  beta[1] <- 0
  alfa[1] <- 0

  # Recursive function for second traversal
  compute_alfa <- function(node) {
    # s7: Compute alfa, top-down
    alfa[node + 1] <<- bitwOr(alfa[nodes[[node + 1]]$parent + 1],
                              bitwAnd(beta[node + 1], -beta[node + 1]))

    if (nodes[[node + 1]]$child != 0) {
      compute_alfa(nodes[[node + 1]]$child)
    }

    # s8: Continue traversal
    if (nodes[[node + 1]]$sib != 0) {
      compute_alfa(nodes[[node + 1]]$sib)
    }
  }

  # Perform second (recursive) traversal if needed
  if (p != 0) {
    compute_alfa(p)
  }

  return(list(pi_ = pi_, beta = beta, alfa = alfa, tau = tau, lam = lam))
}

# Compute the nearest common ancestor (NCA) of two nodes x and y
nca <- function(x, y, beta, alfa, tau, lam, pi_) {
  # Find common height
  if (beta[x + 1] <= beta[y + 1]) {
    h <- lam[bitwAnd(beta[y + 1], -beta[x + 1] + 1) + 1]
  } else {
    h <- lam[bitwAnd(beta[x + 1], -beta[y + 1] + 1) + 1]
  }

  # Find true height
  k <- bitwAnd(bitwAnd(alfa[x + 1], alfa[y + 1]),
               bitwNot(bitwShiftL(1, h)) + 1)
  h <- lam[bitwAnd(k, -k) + 1]

  # Find beta[z]
  j <- bitwShiftL(bitwOr(bitwShiftR(beta[x + 1], h), 1), h)

  # Find x' and y'
  if (j != beta[x + 1]) {
    l <- lam[bitwAnd(alfa[x + 1], bitwShiftL(1, h) - 1) + 1]
    x <- tau[bitwShiftL(bitwOr(bitwShiftR(beta[x + 1], l), 1), l) + 1]
  }

  if (j != beta[y + 1]) {
    l <- lam[bitwAnd(alfa[y + 1], bitwShiftL(1, h) - 1) + 1]
    y <- tau[bitwShiftL(bitwOr(bitwShiftR(beta[y + 1], l), 1), l) + 1]
  }

  # Find z
  if (pi_[x + 1] <= pi_[y + 1]) {
    return(x)
  } else {
    return(y)
  }
}

# Solve a test case using Schieber-Vishkin given values and queries
schiebervishkin <- function(n, values, queries) {
  results <- integer(length(queries))

  a <- c(.Machine$integer.max)
  r <- integer(n + 2)
  b <- integer(n + 2)

  big_n <- 1
  count <- 0
  oldx <- NULL

  for (i in 1:n) {
    x <- values[i]

    if (i > 1 && x != oldx) {
      a <- c(a, count)
      r[big_n + 1] <- i
      big_n <- big_n + 1
      count <- 0
    }

    b[i] <- big_n
    count <- count + 1
    oldx <- x
  }

  a <- c(a, count)
  r[big_n + 1] <- n + 1

  result_process <- process(big_n, a)
  pi_ <- result_process$pi_
  beta <- result_process$beta
  alfa <- result_process$alfa
  tau <- result_process$tau
  lam <- result_process$lam

  for (t in 1:length(queries)) {
    query <- queries[[t]]
    i <- query[1]
    j <- query[2]
    x <- b[i]
    y <- b[j]

    z <- 0
    if (x == y) {
      z <- j - i + 1
    } else {
      if (x + 1 != y) {
        z <- a[nca(x + 1, y - 1, beta, alfa, tau, lam, pi_) + 1]
      }
      z <- max(z, r[x + 1] - i, a[y + 1] - (r[y + 1] - j - 1))
    }
    results[t] <- z
  }

  return(results)
}

# Main function to run test cases
main <- function() {
  # Hard-coded test data
  test_cases <- list(
    list(
      n = 10,
      values = c(-1L, -1L, 1L, 1L, 1L, 1L, 3L, 10L, 10L, 10L),
      queries = list(c(2, 3), c(1, 10), c(5, 10)),
      expected = c(1L, 4L, 3L)
    )
  )

  for (idx in 1:length(test_cases)) {
    test_case <- test_cases[[idx]]
    n <- test_case$n
    values <- test_case$values
    queries <- test_case$queries
    expected <- test_case$expected

    cat("Test Case", idx, ":\n")
    cat("Size:", n, ", Queries:", length(queries), "\n")
    cat("Values:", paste(values, collapse = " "), "\n")

    results <- schiebervishkin(n, values, queries)

    cat("Queries and Results:\n")
    for (q_idx in 1:length(queries)) {
      query <- queries[[q_idx]]
      i <- query[1]
      j <- query[2]
      result <- results[q_idx]
      exp <- expected[q_idx]

      cat("Query:", i, j, "\n")
      cat("Result:", result, "(Expected:", exp, ")\n")
      if (result != exp) {
        cat("  WARNING: Result doesn't match expected output\n")
      }
    }

    cat("\n")
  }
}

# Run the main function
main()
