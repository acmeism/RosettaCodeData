floydWarshall <- function(weights, numVertices) {
  # Initialize distance matrix with infinity
  dist <- matrix(Inf, nrow = numVertices, ncol = numVertices)

  # Set diagonal elements to zero
  diag(dist) <- 0

  # Fill the distance matrix with the given weights
  for (i in 1:nrow(weights)) {
    dist[weights[i, 1], weights[i, 2]] <- weights[i, 3]
  }

  # Initialize nextNode matrix
  nextNode <- matrix(0, nrow = numVertices, ncol = numVertices)
  for (i in 1:numVertices) {
    for (j in 1:numVertices) {
      if (i != j) {
        nextNode[i, j] <- j
      }
    }
  }

  # Floyd-Warshall algorithm
  for (k in 1:numVertices) {
    for (i in 1:numVertices) {
      for (j in 1:numVertices) {
        if (dist[i, k] + dist[k, j] < dist[i, j]) {
          dist[i, j] <- dist[i, k] + dist[k, j]
          nextNode[i, j] <- nextNode[i, k]
        }
      }
    }
  }

  printResult(dist, nextNode)
}

printResult <- function(dist, nextNode) {
  cat("pair dist path\n")
  for (i in 1:nrow(nextNode)) {
    for (j in 1:ncol(nextNode)) {
      if (i != j) {
        u <- i
        v <- j
        path <- sprintf("%d -> %d %2d %s", i, j, dist[i, j], i)
        repeat {
          u <- nextNode[u, v]
          path <- paste(path, "->", u)
          if (u == v) break
        }
        cat(path, "\n")
      }
    }
  }
}

# Example usage
weights <- matrix(c(
  1, 3, -2,
  2, 1, 4,
  2, 3, 3,
  3, 4, 2,
  4, 2, -1
), ncol = 3, byrow = TRUE)

numVertices <- 4
floydWarshall(weights, numVertices)
