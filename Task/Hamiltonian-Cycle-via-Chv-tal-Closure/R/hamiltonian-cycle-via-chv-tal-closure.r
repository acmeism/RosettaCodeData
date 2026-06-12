# Graph structure as a list with n (number of vertices) and adj (adjacency matrix)
Graph <- function(n, adj = NULL) {
  if (is.null(adj)) {
    adj <- matrix(FALSE, nrow = n, ncol = n)
  }
  list(n = n, adj = adj)
}

# Add an undirected edge u--v
add_edge <- function(g, u, v) {
  if (0 < u && u <= g$n && 0 < v && v <= g$n) {
    g$adj[u, v] <- TRUE
    g$adj[v, u] <- TRUE
  }
  g
}

# Degree of vertex u
degree <- function(g, u) {
  sum(g$adj[u, ])
}

# Compute the Chvátal closure in-place
closure <- function(g) {
  n <- g$n
  repeat {
    added <- FALSE
    # Try every non-edge (u,v) with u < v
    found <- FALSE
    for (u in 1:(n-1)) {
      for (v in (u+1):n) {
        if (!g$adj[u, v]) {
          du <- degree(g, u)
          dv <- degree(g, v)
          if (du + dv > n) {
            # add the edge
            g <- add_edge(g, u, v)
            added <- TRUE
            found <- TRUE
            break
          }
        }
      }
      if (found) break
    }
    if (!added) break
  }
  g
}

# Is the graph complete?
is_complete <- function(g) {
  for (u in 1:(g$n-1)) {
    for (v in (u+1):g$n) {
      if (!g$adj[u, v]) {
        return(FALSE)
      }
    }
  }
  TRUE
}

# Depth-first search for Hamiltonian cycle
dfs <- function(g, u, visited, path) {
  if (length(path) == g$n) {
    # check if can close the cycle
    if (g$adj[u, path[1]]) {
      return(c(path, path[1]))
    } else {
      return(NULL)
    }
  }

  for (v in 1:g$n) {
    if (!visited[v] && g$adj[u, v]) {
      visited[v] <- TRUE
      path <- c(path, v)
      cycle <- dfs(g, v, visited, path)
      if (!is.null(cycle)) {
        return(cycle)
      }
      # else backtrack if no cycle yet
      path <- path[-length(path)]
      visited[v] <- FALSE
    }
  }
  NULL
}

# Find a Hamiltonian cycle in the original graph (not closure)
# by simple backtracking. Returns vertices in order (1..n), and back to start.
hamiltonian_cycle <- function(g) {
  visited <- rep(FALSE, g$n)
  # set starting vertex
  path <- 1
  visited[1] <- TRUE
  dfs(g, 1, visited, path)
}

test_hamiltonian <- function() {
  # Example: 5 vertices, almost complete graph missing edge 1--2.
  # This satisfies Ore's condition: any non-edge (1,2) has deg(1)=3, deg(2)=3, 3+3>=5.
  g <- Graph(5)

  # Add all edges except (1,2)
  for (u in 1:4) {
    for (v in (u+1):5) {
      if (!(u == 1 && v == 2)) {
        g <- add_edge(g, u, v)
      }
    }
  }

  cat("Original graph degrees:\n")
  for (u in 1:g$n) {
    cat(sprintf(" deg(%d) = %d\n", u, degree(g, u)))
  }

  # Compute closure (create a copy first)
  c <- Graph(g$n, g$adj)
  c <- closure(c)

  cat("\nAfter Chvátal closure (translated to 0-based indices):\n")
  for (u in 1:c$n) {
    cat(u - 1, ": ")
    for (v in 1:c$n) {
      if (c$adj[u, v]) {
        cat(v - 1, " ")
      }
    }
    cat("\n")
  }

  if (is_complete(c)) {
    cat("\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).\n")
    cycle <- hamiltonian_cycle(g)
    if (!is.null(cycle)) {
      cat("Found Hamiltonian cycle in original graph, as zero-based is:\n")
      for (i in seq_along(cycle)) {
        if (i > 1) cat(" → ")
        cat(cycle[i] - 1)
      }
      cat("\n")
    } else {
      cat("Unexpected: could not find a Hamiltonian cycle.\n")
    }
  } else {
    cat("\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.\n")
  }
}

# Run the test
test_hamiltonian()
