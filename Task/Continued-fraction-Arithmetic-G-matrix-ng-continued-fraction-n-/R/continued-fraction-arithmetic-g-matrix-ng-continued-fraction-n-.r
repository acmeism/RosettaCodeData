# Helper: integer division and remainder (like divrem)
divrem <- function(a, b) {
  q <- a %/% b
  r <- a %% b
  return(list(quotient = q, remainder = r))
}

# Continued fraction from rational number (n1/n2)
r2cf <- function(n1, n2, maxiter = 20) {
  ret <- integer(0)
  iter <- 0
  while (n2 != 0 && iter < maxiter) {
    dr <- divrem(n1, n2)
    t1 <- dr$quotient
    n1_new <- n2
    n2_new <- dr$remainder
    n1 <- n1_new
    n2 <- n2_new
    ret <- c(ret, t1)
    iter <- iter + 1
  }
  return(ret)
}

# S3 method for rational-like input (list with numerator/denominator)
r2cf.rational <- function(r, maxiter = 20) {
  if (is.list(r) && "numerator" %in% names(r) && "denominator" %in% names(r)) {
    return(r2cf(r$numerator, r$denominator, maxiter))
  } else if (length(r) == 2) {
    return(r2cf(r[1], r[2], maxiter))
  } else {
    stop("Invalid rational input")
  }
}

# NG "struct" constructor
NG <- function(a1, a, b1, b) {
  structure(list(a1 = a1, a = a, b1 = b1, b = b), class = "NG")
}

# Ingress: update NG with new term n
ingress <- function(ng, n) {
  new_a <- ng$a1
  new_a1 <- ng$a + ng$a1 * n
  new_b <- ng$b1
  new_b1 <- ng$b + ng$b1 * n
  ng$a <- new_a
  ng$a1 <- new_a1
  ng$b <- new_b
  ng$b1 <- new_b1
  return(ng)
}

# Check if NG needs another term
needterm <- function(ng) {
  if (ng$b == 0 || ng$b1 == 0) return(TRUE)
  frac1 <- ng$a / ng$b
  frac2 <- ng$a1 / ng$b1
  return(!isTRUE(all.equal(frac1, frac2, tolerance = .Machine$double.eps^0.5)))
}

# Egress: emit ONE integer term and update NG state
egress <- function(ng) {
  if (ng$b == 0) stop("Cannot divide by zero in egress")
  n_val <- ng$a %/% ng$b  # integer division — this is the term to emit

  # Update state: (a, b) <- (b, a - b * n)
  new_a <- ng$b
  new_b <- ng$a - ng$b * n_val
  new_a1 <- ng$b1
  new_b1 <- ng$a1 - ng$b1 * n_val

  ng$a <- new_a
  ng$b <- new_b
  ng$a1 <- new_a1
  ng$b1 <- new_b1

  return(list(term = n_val, ng = ng))
}

# Egress done: if needterm, swap (a,b) with (a1,b1), then egress
egress_done <- function(ng) {
  if (needterm(ng)) {
    ng$a <- ng$a1
    ng$b <- ng$b1
  }
  result <- egress(ng)
  return(result)
}

# Check if NG is done
done <- function(ng) {
  return(ng$b == 0 && ng$b1 == 0)
}

# Test function
testng <- function() {
  data <- list(
    list(desc = "[1;5,2] + 1/2",      ng_params = c(2,1,0,2), rat = c(13,11)),
    list(desc = "[3;7] + 1/2",        ng_params = c(2,1,0,2), rat = c(22,7)),
    list(desc = "[3;7] divided by 4", ng_params = c(1,0,0,4), rat = c(22,7)),
    list(desc = "[1;1] divided by sqrt(2)", ng_params = c(0,1,1,0), rat = c(1, sqrt(2)))
  )

  for (d in data) {
    str <- d$desc
    ng_vec <- d$ng_params
    r <- d$rat

    cat(sprintf("%-25s -> [", str))

    # Create NG object
    ng <- NG(ng_vec[1], ng_vec[2], ng_vec[3], ng_vec[4])

    # Get continued fraction terms from input rational
    cf_terms <- r2cf(r[1], r[2])

    output_terms <- integer(0)

    for (n in cf_terms) {
      while (!needterm(ng)) {
        egress_result <- egress(ng)
        output_terms <- c(output_terms, egress_result$term)
        ng <- egress_result$ng
      }
      ng <- ingress(ng, n)
    }

    # Final egress until done
    while (TRUE) {
      egress_result <- egress_done(ng)
      output_terms <- c(output_terms, egress_result$term)
      ng <- egress_result$ng
      if (done(ng)) {
        break
      }
    }

    # Print output as [a, b, c, ...]
    cat(paste(output_terms, collapse = ", "), "]\n")
  }
}

# Run test
testng()
