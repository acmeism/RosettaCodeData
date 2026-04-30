# De Bruijn sequence generator and verifier in R

debruijn <- function(k, n) {
  alphabet <- c(0:9, letters)[1:k]
  a <- integer(k * n)
  seq <- c()

  db <- function(t, p) {
    if (t > n) {
      if (n %% p == 0) {
        seq <<- c(seq, a[2:(p + 1)])
      }
    } else {
      a[t + 1] <<- a[t - p + 1]
      db(t + 1, p)

      if (a[t - p + 1] + 1 <= k - 1) {
        for (j in (a[t - p + 1] + 1):(k - 1)) {
          a[t + 1] <<- j
          db(t + 1, t)
        }
      }
    }
  }

  db(1, 1)

  # Convert to string using alphabet
  result_indices <- c(seq, seq[1:(n-1)])
  result_chars <- alphabet[result_indices + 1]
  return(paste(result_chars, collapse = ""))
}

verifyallPIN <- function(str, k, n, deltaposition = 0) {
  if (deltaposition != 0) {
    str_chars <- strsplit(str, "")[[1]]
    str_chars[deltaposition] <- "."
    str <- paste(str_chars, collapse = "")
  }

  result <- TRUE

  for (i in 0:(k^n - 1)) {
    pin <- sprintf(paste0("%0", n, "d"), i)
    if (!grepl(pin, str, fixed = TRUE)) {
      cat("PIN", pin, "does not occur in the sequence.\n")
      result <- FALSE
    }
  }

  cat("The sequence does", if(result) "" else "not", "contain all PINs.\n")
  return(result)
}

# Main execution
s <- debruijn(10, 4)
cat("The length of the sequence is", nchar(s), ". The first 130 digits are:\n")
cat(substr(s, 1, 130), "\n")
cat("and the last 130 digits are:\n")
cat(substr(s, nchar(s) - 129, nchar(s)), "\n")

cat("Testing sequence: ")
verifyallPIN(s, 10, 4)

cat("Testing the reversed sequence: ")
reversed_s <- paste(rev(strsplit(s, "")[[1]]), collapse = "")
verifyallPIN(reversed_s, 10, 4)

cat("\nAfter replacing 4444th digit with '.':\n")
verifyallPIN(s, 10, 4, 4444)
