library(igraph)

# Constants
chessboard_size <- 8
given_obstacles <- list(c(2,4), c(2,5), c(2,6), c(3,6), c(4,6), c(5,6),
                        c(5,5), c(5,4), c(5,3), c(5,2), c(4,2), c(3,2))

# Helper functions
vfromcart <- function(p, n) {
  (p[1] - 1) * n + p[2]
}

obstacles <- sapply(given_obstacles, function(o) vfromcart(o + 1, chessboard_size))

zbasedpath <- function(path, n) {
  lapply(path, function(v) c(floor((v - 1) / n), (v - 1) %% n))
}

pathcost <- function(path) {
  sum(sapply(path[-1], function(x) ifelse(x %in% obstacles, 100, 1)))
}

surround <- function(x, y, n) {
  bottomx <- ifelse(x > 1, x - 1, x)
  topx <- ifelse(x < n, x + 1, x)
  bottomy <- ifelse(y > 1, y - 1, y)
  topy <- ifelse(y < n, y + 1, y)

  coords <- expand.grid(x = bottomx:topx, y = bottomy:topy)
  lapply(1:nrow(coords), function(i) c(coords$x[i], coords$y[i]))
}

kinggraph <- function(N) {
  edges <- list()
  weights <- c()

  for (row in 1:N) {
    for (col in 1:N) {
      neighbors <- surround(row, col, N)
      origin <- vfromcart(c(row, col), N)

      for (p in neighbors) {
        targ <- vfromcart(p, N)
        hcost <- ifelse(targ %in% obstacles | origin %in% obstacles, 100, 1)
        edges[[length(edges) + 1]] <- c(origin, targ)
        weights <- c(weights, hcost)
      }
    }
  }

  edge_matrix <- do.call(rbind, edges)
  graph <- graph_from_edgelist(edge_matrix, directed = FALSE)
  E(graph)$weight <- weights
  graph
}

# Create graph and find shortest path
kgraph <- kinggraph(chessboard_size)
path <- shortest_paths(kgraph, from = 1, to = 64, weights = E(kgraph)$weight)$vpath[[1]]
path <- as.numeric(path)

cat("Solution has cost", pathcost(path), ":\n")
print(zbasedpath(path, chessboard_size))

# Visualize path
path2graphic <- function(x, path) {
  if (x %in% obstacles) return('█')
  if (x %in% path) return('x')
  return('.')
}

for (row in 8:1) {
  for (col in 7:0) {
    cat(path2graphic(row * 8 - col, path))
  }
  cat("\n")
}
