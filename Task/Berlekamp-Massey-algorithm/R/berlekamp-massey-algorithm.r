# Berlekamp-Massey Algorithm Implementation in R

BerlekampMassey <- function(source, modulus) {
  # Constructor-like function that returns a list with methods

  compute_coefficients <- function() {
    result <- c()
    previous_result <- c()
    fail_index <- -1

    for (i in 1:length(source)) {
      delta <- source[i]

      if (length(result) > 0) {
        for (j in 1:length(result)) {
          if (i - j >= 1) {
            delta <- delta - result[j] * source[i - j]
          }
        }
      }

      if (delta == 0) {
        next
      }

      if (fail_index == -1) {
        result <- rep(0, i)
        fail_index <- i
      } else {
        if (length(previous_result) == 0) {
          previous_result_copy <- c(1)
        } else {
          previous_result_copy <- c(1, -previous_result)
        }

        term_fail_index_plus_one <- 0
        for (j in 1:length(previous_result_copy)) {
          if (fail_index + 2 - j >= 1) {
            term_fail_index_plus_one <- term_fail_index_plus_one +
              previous_result_copy[j] * source[fail_index + 2 - j]
          }
        }

        coeff <- delta / term_fail_index_plus_one
        previous_result_copy <- previous_result_copy * coeff

        # Add zeros at the beginning
        zeros_to_add <- i - fail_index - 2
        if (zeros_to_add > 0) {
          previous_result_copy <- c(rep(0, zeros_to_add), previous_result_copy)
        }

        result_copy <- result

        # Extend result if necessary
        if (length(result) < length(previous_result_copy)) {
          result <- c(result, rep(0, length(previous_result_copy) - length(result)))
        }

        # Add the vectors
        for (j in 1:length(previous_result_copy)) {
          result[j] <- result[j] + previous_result_copy[j]
        }

        if (i - length(result_copy) > fail_index - length(previous_result)) {
          previous_result <- result_copy
          fail_index <- i
        }
      }
    }

    return(result)
  }

  compute_term <- function(bm_coeffs, index) {
    if (length(bm_coeffs) == 0) {
      return(0)
    }

    # Convert to 1-based indexing for R
    index_r <- index + 1

    if (index_r <= length(source)) {
      return((source[index_r] + modulus) %% modulus)
    }

    coeffs <- c(modulus - 1, bm_coeffs)
    bm_coeffs_size <- length(bm_coeffs)

    f <- rep(0, bm_coeffs_size)
    g <- rep(0, bm_coeffs_size)
    f[1] <- 1

    if (bm_coeffs_size == 1) {
      g[1] <- coeffs[2]
    } else {
      g[2] <- 1
    }

    power <- index
    while (power > 0) {
      if (power %% 2 == 1) {
        f <- polynomial_multiply(f, g, bm_coeffs_size, coeffs)
      }
      g <- polynomial_multiply(g, g, bm_coeffs_size, coeffs)
      power <- power %/% 2
    }

    result <- 0
    for (i in 1:bm_coeffs_size) {
      if (i + 1 <= length(source)) {
        result <- (result + source[i + 1] * f[i]) %% modulus
      }
    }

    return((result + modulus) %% modulus)
  }

  polynomial_string <- function(bm_coeffs) {
    degree <- length(bm_coeffs) - 1
    if (degree == 0) {
      return(as.character(bm_coeffs[1]))
    }

    text <- ""
    for (i in (degree + 1):1) {
      coeff <- bm_coeffs[i]
      if (coeff == 0) {
        next
      }

      # Determine sign
      if (coeff < 0 && i == degree + 1) {
        sign <- "-"
      } else if (coeff < 0) {
        sign <- " - "
      } else if (i < degree + 1) {
        sign <- " + "
      } else {
        sign <- ""
      }

      text <- paste0(text, sign)

      coeff_abs <- abs(coeff)
      if (coeff_abs > 1) {
        text <- paste0(text, coeff_abs)
      }

      # Determine term
      if (i - 1 > 1) {
        term <- paste0("x^", i - 1)
      } else if (i - 1 == 1) {
        term <- "x"
      } else if (coeff_abs == 1) {
        term <- "1"
      } else {
        term <- ""
      }

      text <- paste0(text, term)
    }

    return(text)
  }

  polynomial_multiply <- function(a, b, degree, coeffs) {
    result <- rep(0, 2 * degree)

    for (i in 1:degree) {
      if (a[i] == 0) {
        next
      }
      for (j in 1:degree) {
        result[i + j - 1] <- (result[i + j - 1] + a[i] * b[j]) %% modulus
      }
    }

    for (i in (2 * degree):degree) {
      if (result[i] == 0) {
        next
      }
      term <- result[i]
      result[i] <- 0

      for (j in 0:degree) {
        index <- i - j
        if (index >= 1) {
          result[index] <- (result[index] + term * coeffs[j + 1]) %% modulus
        }
      }
    }

    return(result[1:degree])
  }

  # Return list of methods
  list(
    compute_coefficients = compute_coefficients,
    compute_term = compute_term,
    polynomial = polynomial_string
  )
}

# Main execution equivalent
main <- function() {
  source_seq <- c(0, 1, 1, 2, 3, 5, 8, 13, 21)
  bm <- BerlekampMassey(source_seq, 100)

  bm_coeffs <- bm$compute_coefficients()
  cat("Berlekamp-Massey coefficients:", paste(bm_coeffs, collapse = " "), "(lowest to highest degree)\n")
  cat("The connection polynomial is", bm$polynomial(bm_coeffs),
      "having degree", length(bm_coeffs) - 1, "\n\n")

  cat("Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:\n")
  indices <- 35:40
  terms <- sapply(indices, function(n) bm$compute_term(bm_coeffs, n))
  cat(paste(terms, collapse = " "), "\n")
}

# Run the main function
main()
