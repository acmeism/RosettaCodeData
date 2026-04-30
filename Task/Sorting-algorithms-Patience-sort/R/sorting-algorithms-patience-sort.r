patiencesort <- function(list) {
  piles <- list()
  for (n in list) {
    # Find the first pile where the last element is >= n
    i <- sapply(piles, function(pile) n <= tail(pile, 1))
    if (length(piles) == 0 || !any(i)) {
      piles <- append(piles, list(n))
    } else {
      # Find the index of the first TRUE in i
      idx <- which(i)[1]
      piles[[idx]] <- c(piles[[idx]], n)
    }
  }
  mergesorted(piles)
}

mergesorted <- function(vecvec) {
  allsum <- sum(sapply(vecvec, length))
  sorted <- vector("numeric", allsum)
  for (i in 1:allsum) {
    # Find the pile with the smallest last element
    last_elements <- sapply(vecvec, tail, 1)
    idx <- which.min(last_elements)
    sorted[i] <- tail(vecvec[[idx]], 1)
    vecvec[[idx]] <- head(vecvec[[idx]], -1)
    # Remove empty piles
    if (length(vecvec[[idx]]) == 0) {
      vecvec <- vecvec[-idx]
    }
  }
  sorted
}

# Example usage
set.seed(123)
random_list <- sample(1:1000, 12)
print(patiencesort(random_list))
