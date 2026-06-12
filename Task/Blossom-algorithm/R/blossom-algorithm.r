# Edmonds' Blossom algorithm in R

BlossomMatching <- function(nv) {
  list(
    nv = nv,
    matches = integer(nv),        # 0 = unmatched
    parents = integer(nv),
    base_vertices = seq_len(nv),
    used = rep(FALSE, nv),
    blossom = rep(FALSE, nv)
  )
}

# Least common ancestor in the alternating forest
lca <- function(m, a, b) {
  used_path <- rep(FALSE, m$nv)
  repeat {
    a <- m$base_vertices[a]
    used_path[a] <- TRUE
    if (m$matches[a] == 0) break
    a <- m$parents[m$matches[a]]
  }
  repeat {
    b <- m$base_vertices[b]
    if (used_path[b]) return(b)
    b <- m$parents[m$matches[b]]
  }
}

# Mark vertices along path from v to base b, setting their parent to x
mark_path <- function(m, v, b, x) {
  while (m$base_vertices[v] != b) {
    m$blossom[m$base_vertices[v]] <- TRUE
    m$blossom[m$base_vertices[m$matches[v]]] <- TRUE
    m$parents[v] <- x
    x <- m$matches[v]
    v <- m$parents[x]
  }
  m
}

# Try to find an augmenting path starting from root
find_path <- function(m, adj, root) {
  m$used[] <- FALSE
  m$parents[] <- 0L
  m$base_vertices <- seq_len(m$nv)

  # Simple deque using integer vector and head index
  q <- integer(0)
  q_head <- 1L
  push <- function(x) {
    q <<- c(q, x)
  }
  pop <- function() {
    if (q_head > length(q)) return(NULL)
    x <- q[q_head]
    q_head <<- q_head + 1L
    x
  }

  m$used[root] <- TRUE
  push(root)

  while (TRUE) {
    v <- pop()
    if (is.null(v)) break
    for (u in adj[[v]]) {
      if (m$base_vertices[v] == m$base_vertices[u] || m$matches[v] == u) {
        next
      }
      if (u == root || (m$matches[u] != 0 && m$parents[m$matches[u]] != 0)) {
        curbase <- lca(m, v, u)
        m$blossom[] <- FALSE
        m <- mark_path(m, v, curbase, u)
        m <- mark_path(m, u, curbase, v)
        # contract blossom
        for (i in seq_len(m$nv)) {
          if (m$blossom[m$base_vertices[i]]) {
            m$base_vertices[i] <- curbase
            if (!m$used[i]) {
              m$used[i] <- TRUE
              push(i)
            }
          }
        }
      } else if (m$parents[u] == 0) {
        m$parents[u] <- v
        if (m$matches[u] == 0) {
          # augment path
          curr <- u
          while (curr != 0) {
            prev <- m$parents[curr]
            nxt <- if (prev != 0) m$matches[prev] else 0L
            m$matches[curr] <- prev
            m$matches[prev] <- curr
            curr <- nxt
          }
          return(list(found = TRUE, m = m))
        }
        m$used[m$matches[u]] <- TRUE
        push(m$matches[u])
      }
    }
  }
  list(found = FALSE, m = m)
}

# Public API: maximum matching
# adj is a list where adj[[u]] is an integer vector of neighbors of u (1-based).
max_matching <- function(n, adj) {
  if (n <= 0) return(list(match = integer(0), size = 0L))
  m <- BlossomMatching(n)

  match_count <- 0L
  for (v in seq_len(n)) {
    if (m$matches[v] == 0) {
      res <- find_path(m, adj, v)
      m <- res$m
      if (res$found) match_count <- match_count + 1L
    }
  }
  list(match = m$matches, size = match_count)
}

# Test with a 5-cycle (odd cycle)
test_blossom <- function() {
  nv <- 5L
  edges <- list(
    c(0L, 1L), c(1L, 2L), c(2L, 3L), c(3L, 4L), c(4L, 0L)
  )
  adj <- replicate(nv, integer(0), simplify = FALSE)
  for (e in edges) {
    u <- e[1] + 1L
    v <- e[2] + 1L
    adj[[u]] <- c(adj[[u]], v)
    adj[[v]] <- c(adj[[v]], u)  # undirected edges (ensure both directions)
  }

  res <- max_matching(nv, adj)
  matches <- res$match
  msize <- res$size

  cat(sprintf("Maximum matching size: %d\n", msize))
  cat("Matched pairs:\n")
  seen <- new.env(parent = emptyenv())
  for (u in seq_along(matches)) {
    v <- matches[u]
    if (v != 0) {
      key1 <- paste(u, v, sep = "-")
      key2 <- paste(v, u, sep = "-")
      if (is.null(seen[[key1]]) && is.null(seen[[key2]])) {
        cat(sprintf("  %d – %d\n", u - 1L, v - 1L)) # output 0-based like Julia example
        seen[[key1]] <- TRUE
        seen[[key2]] <- TRUE
      }
    }
  }
}

# Run test
test_blossom()
