# Check if a vector has the zigzag property
# (alternating less-than and greater-than comparisons)
is_zigzag <- function(a) {
  if (length(a) <= 1) return(TRUE)

  for (i in 1:(length(a) - 1)) {
    if (i %% 2 == 1) {  # odd index (1-based): should be a[i] < a[i+1]
      if (a[i] >= a[i + 1]) return(FALSE)
    } else {  # even index: should be a[i] > a[i+1]
      if (a[i] <= a[i + 1]) return(FALSE)
    }
  }
  return(TRUE)
}

# Generate the next zigzag permutation
# Takes a vector and returns a list with the modified vector and success flag
next_zigzag_perm <- function(itr) {
  while (TRUE) {
    if (length(itr) <= 1) break

    # Find the largest index i such that itr[i] < itr[i+1]
    i <- NULL
    for (idx in (length(itr) - 1):1) {
      if (itr[idx + 1] > itr[idx]) {
        i <- idx
        break
      }
    }

    if (is.null(i)) {
      # No such index found, reverse the entire array and break
      itr <- rev(itr)
      return(list(itr = itr, success = FALSE))
    }

    # Find the largest index j such that itr[j] > itr[i]
    j <- NULL
    for (idx in length(itr):(i + 1)) {
      if (itr[idx] > itr[i]) {
        j <- idx
        break
      }
    }

    # Swap itr[i] and itr[j]
    temp <- itr[i]
    itr[i] <- itr[j]
    itr[j] <- temp

    # Reverse the suffix starting at itr[i+1]
    if (i + 1 <= length(itr)) {
      itr[(i + 1):length(itr)] <- rev(itr[(i + 1):length(itr)])
    }

    if (is_zigzag(itr)) {
      return(list(itr = itr, success = TRUE))
    }
  }

  return(list(itr = itr, success = FALSE))
}

# Generate all zigzag permutations of length n
generate_zigzag_perms <- function(n) {
  if (n <= 0) return(list())
  if (n == 1) return(list(1))

  perms <- list()
  state <- 1:n

  # Check if the initial permutation is zigzag
  if (is_zigzag(state)) {
    perms <- append(perms, list(state))
  }

  # Generate remaining zigzag permutations
  repeat {
    result <- next_zigzag_perm(state)
    state <- result$itr

    if (!result$success) break

    perms <- append(perms, list(state))
  }

  return(perms)
}

# Test function to generate and display zigzag permutations
test_zigzags <- function(n_listings, n_totals) {
  # Display zigzag permutations for small values of n
  for (n in 1:n_listings) {
    cat("\n\nZigZag Permutations for N =", n, ":\n")

    if (n < 3) {
      cat(paste(1:n, collapse = " "), "\n")
    } else {
      perms <- generate_zigzag_perms(n)
      for (perm in perms) {
        cat(paste(perm, collapse = " "), " ")
      }
      cat("\n")
    }
  }

  # Calculate zigzag numbers using dynamic programming
  # This uses the Euler zigzag number recurrence relation
  zzn <- c(1)  # A(1) = 1
  cat("\nN     Zigzags\n")
  cat("--------------------------------\n")
  cat(" 1    1\n")

  for (m in 1:(n_totals - 1)) {
    if (m %% 2 == 0) {  # even m
      # zzn = [reverse(cumsum(reverse(zzn))); 0]
      zzn <- c(rev(cumsum(rev(zzn))), 0)
    } else {  # odd m
      # zzn = [0; cumsum(zzn)]
      zzn <- c(0, cumsum(zzn))
    }
    cat(sprintf("%2d    %s\n", m + 1, format(sum(zzn), scientific = FALSE)))
  }
}

# Run the test
test_zigzags(5, 30)
