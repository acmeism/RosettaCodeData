library(R6)

# Constants
NIL <- 1
INF <- .Machine$integer.max

# HKGraph class
HKGraph <- R6Class("HKGraph",
  public = list(
    m = NULL,
    n = NULL,
    adj = NULL,
    pair_u = NULL,
    pair_v = NULL,
    dist = NULL,

    initialize = function(m, n) {
      self$m <- m
      self$n <- n
      self$adj <- vector("list", m + 1)
      self$pair_u <- rep(NIL, m + 1)
      self$pair_v <- rep(NIL, n + 1)
      self$dist <- rep(INF, m + 1)
    },

    add_edge = function(u, v) {
      if (u >= 2 & u <= self$m + 1 & v >= 2 & v <= self$n + 1) {
        self$adj[[u]] <- c(self$adj[[u]], v)
      } else {
        warning(paste0("Attempted to add edge (", u, ", ", v, ") outside graph bounds [2..", self$m + 1, "], [2..", self$n + 1, "]"))
      }
    }
  )
)

# BFS function
bfs <- function(g) {
  queue <- c()
  # Reset distances
  for (u in 2:(g$m + 1)) {
    if (g$pair_u[u] == NIL) {
      g$dist[u] <- 0
      queue <- c(queue, u)
    } else {
      g$dist[u] <- INF
    }
  }
  g$dist[NIL] <- INF

  while (length(queue) > 0) {
    u <- queue[1]
    queue <- queue[-1]
    if (g$dist[u] < g$dist[NIL]) {
      for (v in g$adj[[u]]) {
        matched_u <- g$pair_v[v]
        if (g$dist[matched_u] == INF) {
          g$dist[matched_u] <- g$dist[u] + 1
          queue <- c(queue, matched_u)
        }
      }
    }
  }
  return(g$dist[NIL] != INF)
}

# DFS function
dfs <- function(g, u) {
  if (u != NIL) {
    for (v in g$adj[[u]]) {
      matched_u <- g$pair_v[v]
      if (g$dist[matched_u] == g$dist[u] + 1) {
        if (dfs(g, matched_u)) {
          g$pair_v[v] <- u
          g$pair_u[u] <- v
          return(TRUE)
        }
      }
    }
    g$dist[u] <- INF
    return(FALSE)
  }
  return(TRUE)
}

# Main Hopcroft-Karp function
hopcroft_karp_algorithm <- function(g) {
  # Reset matching
  g$pair_u <- rep(NIL, g$m + 1)
  g$pair_v <- rep(NIL, g$n + 1)
  matching_size <- 0

  while (bfs(g)) {
    for (u in 2:(g$m + 1)) {
      if (g$pair_u[u] == NIL & dfs(g, u)) {
        matching_size <- matching_size + 1
      }
    }
  }

  return(matching_size)
}

# Test cases
hk_g_tests <- function() {
  cat("Running tests...\n")

  # Test 1
  g1 <- HKGraph$new(3, 5)
  g1$add_edge(2, 5)
  res1 <- hopcroft_karp_algorithm(g1)
  expected_res1 <- 1
  cat("Test 1: Result =", res1, ", Expected =", expected_res1, "\n")
  stopifnot(res1 == expected_res1)

  # Test 2
  g2 <- HKGraph$new(6, 6)
  g2$add_edge(2, 5)
  g2$add_edge(2, 6)
  g2$add_edge(6, 2)
  res2 <- hopcroft_karp_algorithm(g2)
  expected_res2 <- 2
  cat("Test 2: Result =", res2, ", Expected =", expected_res2, "\n")
  stopifnot(res2 == expected_res2)

  # Test 3: Complete Bipartite Graph K_{3,3}
  g3 <- HKGraph$new(3, 3)
  for (i in 2:4) {
    for (j in 2:4) {
      g3$add_edge(i, j)
    }
  }
  res3 <- hopcroft_karp_algorithm(g3)
  expected_res3 <- 3
  cat("Test 3: Result =", res3, ", Expected =", expected_res3, "\n")
  stopifnot(res3 == expected_res3)

  # Test 4: No edges
  g4 <- HKGraph$new(2, 2)
  res4 <- hopcroft_karp_algorithm(g4)
  expected_res4 <- 0
  cat("Test 4: Result =", res4, ", Expected =", expected_res4, "\n")
  stopifnot(res4 == expected_res4)

  cat("All tests passed!\n")
}

# Hard-coded example run
all_hk_tests <- function() {
  hk_g_tests()
  cat("\n--- Running main execution with hard-coded input ---\n")

  # Hardcoded data
  hardcoded_v1 <- 4
  hardcoded_v2 <- 4
  hardcoded_edges <- list(
    c(2, 2),
    c(2, 4),
    c(3, 4),
    c(4, 5),
    c(5, 4),
    c(5, 3)
  )

  v1 <- hardcoded_v1
  v2 <- hardcoded_v2
  edges_data <- hardcoded_edges
  e_len <- length(edges_data)

  g <- HKGraph$new(v1, v2)
  cat("Hard-coded graph dimensions: m=", v1, ", n=", v2, ", edges=", e_len, "\n")
  cat("Adding hard-coded edges:\n")

  for (edge in edges_data) {
    u <- edge[1]
    v <- edge[2]
    cat("  Adding edge: 2-based (", u, ", ", v, ")\n")
    if (u >= 2 & u <= v1 + 1 & v >= 2 & v <= v2 + 1) {
      g$add_edge(u, v)
    } else {
      cat("Warning: Skipping invalid hard-coded edge (", u, ", ", v, ")\n")
    }
  }

  max_matching_size <- hopcroft_karp_algorithm(g)
  cat("Maximum matching size is", max_matching_size, "\n")
}

# Run all tests and main example
all_hk_tests()
