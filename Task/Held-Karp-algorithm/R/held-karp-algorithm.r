# Solve the Traveling Salesman Problem using the Held-Karp algorithm.
# dist is a list of lists representing pairwise distances.
# Returns a list with min_cost and tour (vector of node indices, starting
# and ending at 1).
heldkarp <- function(dist) {
  INF <- .Machine$integer.max

  n <- length(dist)
  N <- bitwShiftL(1, n)  # Number of subsets 2^n

  # dp[[mask]][[j]] = minimum cost to reach subset 'mask' and end at node j
  dp <- vector("list", N)
  for (i in 1:N) {
    dp[[i]] <- rep(INF, n)
  }

  # parent[[mask]][[j]] = previous node before j in optimal path for (mask, j)
  parent <- vector("list", N)
  for (i in 1:N) {
    parent[[i]] <- rep(-1, n)
  }

  # Base case: start at node 1, mask = 1<<0 = 1
  dp[[2]][[1]] <- 0  # mask=1 is index 2 (1+1)

  # Iterate over all subsets that include node 1
  for (mask in seq(1, N-1, by=2)) {  # Only odd masks (include node 1)
    for (j in 2:n) {
      # Check if j is in subset
      if (bitwAnd(mask, bitwShiftL(1, j-1)) == 0) next

      prev_mask <- bitwXor(mask, bitwShiftL(1, j-1))

      # Try all possibilities of coming to j from some k in prev_mask
      for (k in 1:n) {
        if (bitwAnd(prev_mask, bitwShiftL(1, k-1)) == 0) next

        cost <- dp[[prev_mask + 1]][[k]] + dist[[k]][[j]]
        if (cost < dp[[mask + 1]][[j]]) {
          dp[[mask + 1]][[j]] <- cost
          parent[[mask + 1]][[j]] <- k
        }
      }
    }
  }

  # Close the tour: return to node 1
  full_mask <- N - 1
  min_cost <- INF
  last <- 0

  for (j in 2:n) {
    cost <- dp[[full_mask + 1]][[j]] + dist[[j]][[1]]
    if (cost < min_cost) {
      min_cost <- cost
      last <- j
    }
  }

  # Reconstruct path
  path <- c()
  mask <- full_mask
  curr <- last

  while (curr != 1) {
    path <- c(path, curr)
    prev <- parent[[mask + 1]][[curr]]
    mask <- bitwXor(mask, bitwShiftL(1, curr - 1))
    curr <- prev
  }

  path <- c(path, 1)          # add the start node
  path <- rev(path)           # reverse to get 1 -> ... -> last
  path <- c(path, 1)          # and return to 1

  return(list(min_cost = min_cost, tour = path))
}

test_tour <- function() {
  # Example test case: 4 cities, symmetric distances
  dist_matrix <- list(
    c(0, 2, 9, 10),
    c(1, 0, 6, 4),
    c(15, 7, 0, 8),
    c(6, 3, 12, 0)
  )

  result <- heldkarp(dist_matrix)
  cat("Minimum tour cost:", result$min_cost, "\n")
  cat("Tour:", result$tour, "\n")
}

test_tour()
