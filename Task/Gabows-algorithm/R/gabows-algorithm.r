# Define Digraph class
Digraph <- function(v) {
  stopifnot(v >= 0)
  structure(list(
    v = v,
    e = 0,
    adj = replicate(v, integer(0), simplify = FALSE)
  ), class = "Digraph")
}

# Number of vertices
nv <- function(g) UseMethod("nv")
nv.Digraph <- function(g) g$v

# Number of edges
ne <- function(g) UseMethod("ne")
ne.Digraph <- function(g) g$e

# Validate vertex
validatevertex <- function(g, v) {
  if (!isTRUE(v > 0 & v <= g$v)) {
    stop(paste0("Domain error with v ", v, ": required that 0 < v <= ", g$v))
  }
}

# Add directed edge
addedge <- function(g, v, w) {
  UseMethod("addedge")
}
addedge.Digraph <- function(g, v, w) {
  validatevertex(g, v)
  validatevertex(g, w)
  g$adj[[v]] <- c(g$adj[[v]], w)
  g$e <- g$e + 1
  g
}

# Adjacent list
adj <- function(g, v) {
  UseMethod("adj")
}
adj.Digraph <- function(g, v) {
  validatevertex(g, v)
  g$adj[[v]]
}

# Print method
print.Digraph <- function(x, zerobasedoutput = TRUE, ...) {
  cat(nv(x), "vertices,", ne(x), "edges\n")
  for (i in seq_along(x$adj)) {
    adj_list <- if (zerobasedoutput) x$adj[[i]] - 1 else x$adj[[i]]
    cat(i - zerobasedoutput, ": ", paste(adj_list, collapse = " "), "\n", sep = "")
  }
}

# GabowSCC class
GabowSCC <- function(g) {
  marked <- rep(FALSE, nv(g))
  id <- rep(-1L, nv(g))
  preorder <- integer(nv(g))
  precounter <- 0L
  scc_count <- 1L
  stack1 <- integer(0)
  stack2 <- integer(0)

  # Create environment to hold mutable state
  env <- new.env()
  env$marked <- marked
  env$id <- id
  env$preorder <- preorder
  env$precounter <- precounter
  env$scc_count <- scc_count
  env$stack1 <- stack1
  env$stack2 <- stack2

  # DFS function with access to environment
  dfs <- function(v) {
    env$marked[v] <<- TRUE
    env$precounter <<- env$precounter + 1L
    env$preorder[v] <<- env$precounter
    env$stack1 <<- c(env$stack1, v)
    env$stack2 <<- c(env$stack2, v)

    for (w in adj(g, v)) {
      if (!env$marked[w]) {
        dfs(w)
      } else if (env$id[w] == -1L) {
        while (length(env$stack2) > 0 && env$preorder[tail(env$stack2, 1)] > env$preorder[w]) {
          env$stack2 <<- head(env$stack2, -1)
        }
      }
    }

    if (length(env$stack2) > 0 && tail(env$stack2, 1) == v) {
      env$stack2 <<- head(env$stack2, -1)

      repeat {
        w <- tail(env$stack1, 1)
        env$stack1 <<- head(env$stack1, -1)
        env$id[w] <<- env$scc_count
        if (w == v) break
      }
      env$scc_count <<- env$scc_count + 1L
    }
  }

  # Run DFS on all unvisited vertices
  for (v in 1:nv(g)) {
    if (!env$marked[v]) {
      dfs(v)
    }
  }

  # Return the SCC object with results
  structure(list(
    id = env$id,
    scc_count = env$scc_count,
    marked = env$marked
  ), class = "GabowSCC")
}

# Number of SCCs
count <- function(scc) UseMethod("count")
count.GabowSCC <- function(scc) scc$scc_count - 1L

# Validate vertex for SCC
validatevertex_scc <- function(scc, v) {
  len <- length(scc$marked)
  if (!isTRUE(v > 0 & v <= len)) {
    stop(paste0("vertex ", v, " is not between 0 and ", len))
  }
}

# Check if two vertices are strongly connected
stronglyconnected <- function(scc, v, w) {
  UseMethod("stronglyconnected")
}
stronglyconnected.GabowSCC <- function(scc, v, w) {
  validatevertex_scc(scc, v)
  validatevertex_scc(scc, w)
  scc$id[v] != -1L && scc$id[v] == scc$id[w]
}

# Get component ID
id <- function(scc, v) {
  UseMethod("id")
}
id.GabowSCC <- function(scc, v) {
  validatevertex_scc(scc, v)
  scc$id[v]
}

# Test function
testgabow <- function() {
  numVertices <- 13
  g <- Digraph(numVertices)

  edges <- list(
    c(4, 2), c(2, 3), c(3, 2), c(6, 0), c(0, 1), c(2, 0), c(11, 12),
    c(12, 9), c(9, 10), c(9, 11), c(8, 9), c(10, 12), c(0, 5), c(5, 4),
    c(3, 5), c(6, 4), c(6, 9), c(7, 6), c(7, 8), c(8, 7), c(5, 3), c(0, 6)
  )

  for (e in edges) {
    g <- addedge(g, e[1] + 1, e[2] + 1)
  }

  print(g)

  scc <- GabowSCC(g)

  m <- count(scc)
  cat(m, "strongly connected components:\n")

  components <- replicate(m, integer(0), simplify = FALSE)

  for (v in 1:nv(g)) {
    cid <- id(scc, v)
    if (cid != -1) {
      components[[cid]] <- c(components[[cid]], v)
    } else {
      cat("Warning: Vertex", v, "has no SCC ID assigned.\n")
    }
  }

  for (i in 1:m) {
    cat("Component", i - 1, ": ", paste(components[[i]] - 1, collapse = " "), "\n")
  }

  cat("\nConnectivity checks:\n")
  for (pair in list(c(0, 3), c(0, 7), c(9, 12))) {
    v <- pair[1] + 1
    w <- pair[2] + 1
    result <- stronglyconnected(scc, v, w)
    cat("Vertices", pair[1], "and", pair[2], "strongly connected?", result, "\n")
  }

  cat("ID of vertex 5:", id(scc, 5 + 1) - 1, "\n")
  cat("ID of vertex 8:", id(scc, 8 + 1) - 1, "\n")
}

# Run the test
testgabow()
