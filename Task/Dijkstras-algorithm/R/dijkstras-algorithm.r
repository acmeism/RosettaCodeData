# Digraph class implementation using S3
create_digraph <- function(edges) {
  # Extract vertex names from edges
  vnames <- unique(c(edges[, 1], edges[, 2]))

  # Create adjacency list as named list
  adjmat <- list()
  for (i in 1:nrow(edges)) {
    key <- paste(edges[i, 1], edges[i, 2], sep = "->")
    adjmat[[key]] <- as.numeric(edges[i, 3])
  }

  # Create digraph object
  digraph <- list(
    edges = adjmat,
    verts = vnames
  )
  class(digraph) <- "Digraph"
  return(digraph)
}

# Accessor functions
vertices <- function(g) {
  return(g$verts)
}

edges <- function(g) {
  return(g$edges)
}

# Get neighbours of a vertex
neighbours <- function(g, v) {
  neigh <- list()
  edge_names <- names(g$edges)

  for (edge_name in edge_names) {
    parts <- strsplit(edge_name, "->")[[1]]
    if (parts[1] == v) {
      neigh[[parts[2]]] <- g$edges[[edge_name]]
    }
  }
  return(neigh)
}

# Dijkstra's shortest path algorithm
dijkstra_path <- function(g, source, dest) {
  # Check if source is in graph
  if (!(source %in% vertices(g))) {
    stop(paste(source, "is not a vertex in the graph"))
  }

  # Easy case
  if (source == dest) {
    return(list(path = c(source), cost = 0))
  }

  # Initialize variables
  inf <- Inf
  verts <- vertices(g)
  dist <- setNames(rep(inf, length(verts)), verts)
  prev <- setNames(verts, verts)
  dist[source] <- 0
  Q <- verts

  # Precompute neighbours for all vertices
  neigh <- list()
  for (v in verts) {
    neigh[[v]] <- neighbours(g, v)
  }

  # Main loop
  while (length(Q) > 0) {
    # Find vertex with minimum distance
    u <- Q[which.min(dist[Q])]
    Q <- Q[Q != u]

    if (dist[u] == inf || u == dest) break

    # Update distances to neighbours
    for (v_name in names(neigh[[u]])) {
      if (v_name %in% Q) {
        alt <- dist[u] + neigh[[u]][[v_name]]
        if (alt < dist[v_name]) {
          dist[v_name] <- alt
          prev[v_name] <- u
        }
      }
    }
  }

  # Reconstruct path
  path <- c()
  cost <- dist[dest]

  if (prev[dest] == dest) {
    return(list(path = path, cost = cost))
  } else {
    current <- dest
    while (current != source) {
      path <- c(current, path)
      current <- prev[current]
    }
    path <- c(current, path)
    return(list(path = path, cost = cost))
  }
}

# Test data
testgraph <- matrix(c(
  "a", "b", 7,
  "a", "c", 9,
  "a", "f", 14,
  "b", "c", 10,
  "b", "d", 15,
  "c", "d", 11,
  "c", "f", 2,
  "d", "e", 6,
  "e", "f", 9
), ncol = 3, byrow = TRUE)

# Convert weights to numeric
testgraph[, 3] <- as.numeric(testgraph[, 3])

# Test function
test_paths <- function() {
  g <- create_digraph(testgraph)
  src <- "a"
  dst <- "e"

  result <- dijkstra_path(g, src, dst)
  path <- result$path
  cost <- result$cost

  cat("Shortest path from", src, "to", dst, ": ")
  if (length(path) == 0) {
    cat("no possible path")
  } else {
    cat(paste(path, collapse = " → "))
  }
  cat(" (cost", cost, ")\n")

  # Print all possible paths
  cat("\n")
  cat(sprintf("%4s | %3s | %s\n", "src", "dst", "path"))
  cat("----------------\n")

  for (src in vertices(g)) {
    for (dst in vertices(g)) {
      result <- dijkstra_path(g, src, dst)
      path <- result$path
      cost <- result$cost

      path_str <- if (length(path) == 0) {
        "no possible path"
      } else {
        paste0(paste(path, collapse = " → "), " (", cost, ")")
      }

      cat(sprintf("%4s | %3s | %s\n", src, dst, path_str))
    }
  }
}

# Run the test
test_paths()
