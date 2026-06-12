# TSP Christofides Algorithm Implementation in R

# Helper function to print containers
print_container <- function(container, name, zerobase = TRUE) {
  cat(sprintf("%s: %s\n", name, paste(container - as.numeric(zerobase), collapse = ", ")))
}

# Helper function to print graph edges
print_edges <- function(edges, name, zerobase = TRUE) {
  cat(sprintf("%s: [", name))
  for (i in seq_along(edges)) {
    edge <- edges[[i]]
    u <- edge$u - as.numeric(zerobase)
    v <- edge$v - as.numeric(zerobase)
    if (i > 1 && i < length(edges)) cat(", ")
    cat(sprintf("(%d, %d, %.2f)", u, v, edge$weight))
  }
  cat("]\n")
}

# Helper function to print graph
print_graph <- function(graph, name, zerobase = TRUE) {
  cat(sprintf("%s: {\n", name))
  n <- nrow(graph)
  for (i in 1:n) {
    cat(sprintf("  %d: {", i - as.numeric(zerobase)))
    first <- TRUE
    for (j in 1:n) {
      if (i != j) {
        if (!first) cat(", ")
        cat(sprintf("%d: %.2f", j - as.numeric(zerobase), graph[i, j]))
        first <- FALSE
      }
    }
    cat(sprintf("}%s\n", ifelse(i == n, "", ",")))
  }
  cat("}\n")
}

# Euclidean distance function
get_length <- function(p1, p2) {
  sqrt((p1$x - p2$x)^2 + (p1$y - p2$y)^2)
}

# Build complete graph (adjacency matrix)
build_graph <- function(data) {
  n <- length(data)
  graph <- matrix(0, n, n)
  for (i in 1:n) {
    for (j in (i+1):n) {
      if (j <= n) {
        dist <- get_length(data[[i]], data[[j]])
        graph[i, j] <- dist
        graph[j, i] <- dist
      }
    }
  }
  return(graph)
}

# Union-Find data structure
create_union_find <- function(n) {
  list(
    parent = 1:n,
    rank = rep(0, n)
  )
}

# Find function with path compression
find_uf <- function(uf, i) {
  if (uf$parent[i] == i) {
    return(i)
  }
  uf$parent[i] <- find_uf(uf, uf$parent[i])
  return(uf$parent[i])
}

# Union function by rank
unite_uf <- function(uf, i, j) {
  rootI <- find_uf(uf, i)
  rootJ <- find_uf(uf, j)
  if (rootI != rootJ) {
    if (uf$rank[rootI] < uf$rank[rootJ]) {
      uf$parent[rootI] <- rootJ
    } else if (uf$rank[rootI] > uf$rank[rootJ]) {
      uf$parent[rootJ] <- rootI
    } else {
      uf$parent[rootJ] <- rootI
      uf$rank[rootI] <- uf$rank[rootI] + 1
    }
  }
}

# Create edge list
create_edge <- function(u, v, weight) {
  list(u = u, v = v, weight = weight)
}

# Minimum Spanning Tree (Kruskal's Algorithm)
minimum_spanning_tree <- function(graph) {
  n <- nrow(graph)
  if (n == 0) return(list())

  edges <- list()
  for (i in 1:n) {
    for (j in (i+1):n) {
      if (j <= n) {
        edges <- append(edges, list(create_edge(i, j, graph[i, j])), after = length(edges))
      }
    }
  }

  # Sort edges by weight
  edges <- edges[order(sapply(edges, function(e) e$weight))]

  mst <- list()
  uf <- create_union_find(n)
  edges_count <- 0

  for (edge in edges) {
    if (find_uf(uf, edge$u) != find_uf(uf, edge$v)) {
      mst <- append(mst, list(edge), after = length(mst))
      unite_uf(uf, edge$u, edge$v)
      edges_count <- edges_count + 1
      if (edges_count == n - 1) break
    }
  }

  return(mst)
}

# Find vertices with odd degree in MST
find_odd_vertices <- function(mst, n) {
  degree <- rep(0, n)
  for (edge in mst) {
    degree[edge$u] <- degree[edge$u] + 1
    degree[edge$v] <- degree[edge$v] + 1
  }
  return(which(degree %% 2 == 1))
}

# Minimum weight matching (greedy heuristic)
minimum_weight_matching <- function(mst, graph, odd_vertices) {
  current_odd <- sample(odd_vertices)  # Shuffle for randomness
  matched <- rep(FALSE, nrow(graph))

  for (i in seq_along(current_odd)) {
    v <- current_odd[i]
    if (matched[v]) next  # Skip if already matched

    min_length <- .Machine$double.xmax
    closest_u <- -1

    # Find the closest unmatched odd vertex
    if (i < length(current_odd)) {
      for (j in (i+1):length(current_odd)) {
        u <- current_odd[j]
        if (!matched[u]) {
          if (graph[v, u] < min_length) {
            min_length <- graph[v, u]
            closest_u <- u
          }
        }
      }
    }

    if (closest_u != -1) {
      # Add the matching edge to the MST list
      mst <- append(mst, list(create_edge(v, closest_u, min_length)), after = length(mst))
      matched[v] <- TRUE
      matched[closest_u] <- TRUE
    }
  }

  return(mst)
}

# Find Eulerian tour (Hierholzer's algorithm)
find_eulerian_tour <- function(matched_mst, n) {
  if (length(matched_mst) == 0) return(integer(0))

  # Build adjacency list representation
  adj <- vector("list", n)
  for (i in 1:n) {
    adj[[i]] <- list()
  }

  edge_used <- list()

  for (i in seq_along(matched_mst)) {
    edge <- matched_mst[[i]]
    adj[[edge$u]] <- append(adj[[edge$u]], list(list(neighbor = edge$v, edge_idx = i)), after = length(adj[[edge$u]]))
    adj[[edge$v]] <- append(adj[[edge$v]], list(list(neighbor = edge$u, edge_idx = i)), after = length(adj[[edge$v]]))
    edge_used[[i]] <- FALSE
  }

  tour <- integer(0)
  current_path <- integer(0)

  # Start at any vertex with edges
  start_node <- matched_mst[[1]]$u
  current_path <- c(current_path, start_node)

  while (length(current_path) > 0) {
    current_node <- current_path[length(current_path)]
    found_edge <- FALSE

    # Find an unused edge from current node
    for (neighbor_info in adj[[current_node]]) {
      neighbor <- neighbor_info$neighbor
      edge_idx <- neighbor_info$edge_idx

      if (!edge_used[[edge_idx]]) {
        edge_used[[edge_idx]] <- TRUE
        current_path <- c(current_path, neighbor)
        found_edge <- TRUE
        break
      }
    }

    # If no unused edge found, backtrack
    if (!found_edge) {
      tour <- c(tour, current_path[length(current_path)])
      current_path <- current_path[-length(current_path)]
    }
  }

  return(rev(tour))
}

# Main TSP function (Christofides approximation)
tsp <- function(data) {
  n <- length(data)
  if (n == 0) return(list(length = 0.0, path = integer(0)))
  if (n == 1) return(list(length = 0.0, path = data[[1]]$id))

  # Build graph
  g <- build_graph(data)
  ms_tree <- minimum_spanning_tree(g)
  print_edges(ms_tree, "MSTree")

  # Find odd degree vertices
  odd_vertices <- find_odd_vertices(ms_tree, n)
  print_container(odd_vertices, "Odd vertices in MSTree")

  # Add minimum weight matching edges
  ms_tree <- minimum_weight_matching(ms_tree, g, odd_vertices)
  print_edges(ms_tree, "Minimum weight matching (MST + Matching Edges)")

  # Find Eulerian tour
  eulerian_tour <- find_eulerian_tour(ms_tree, n)
  print_container(eulerian_tour, "Eulerian tour")

  # Create Hamiltonian circuit by skipping visited nodes
  if (length(eulerian_tour) == 0) {
    cat("Error: Eulerian tour could not be found.\n")
    return(list(length = -1.0, path = integer(0)))
  }

  path <- integer(0)
  len <- 0.0
  visited <- rep(FALSE, n)

  current <- eulerian_tour[1]
  path <- c(path, current)
  visited[current] <- TRUE

  for (v in eulerian_tour) {
    if (!visited[v]) {
      path <- c(path, v)
      visited[v] <- TRUE
      len <- len + g[current, v]
      current <- v
    }
  }

  # Add edge back to start
  len <- len + g[current, path[1]]
  path <- c(path, path[1])

  print_container(path, "Result path")
  cat(sprintf("Result length of the path: %.2f\n", len))

  return(list(length = len, path = path))
}

# Input data matching the original example
raw_data <- list(
  c(1380, 939), c(2848, 96), c(3510, 1671), c(457, 334), c(3888, 666), c(984, 965), c(2721, 1482), c(1286, 525),
  c(2716, 1432), c(738, 1325), c(1251, 1832), c(2728, 1698), c(3815, 169), c(3683, 1533), c(1247, 1945), c(123, 862),
  c(1234, 1946), c(252, 1240), c(611, 673), c(2576, 1676), c(928, 1700), c(53, 857), c(1807, 1711), c(274, 1420),
  c(2574, 946), c(178, 24), c(2678, 1825), c(1795, 962), c(3384, 1498), c(3520, 1079), c(1256, 61), c(1424, 1728),
  c(3913, 192), c(3085, 1528), c(2573, 1969), c(463, 1670), c(3875, 598), c(298, 1513), c(3479, 821), c(2542, 236),
  c(3955, 1743), c(1323, 280), c(3447, 1830), c(2936, 337), c(1621, 1830), c(3373, 1646), c(1393, 1368),
  c(3874, 1318), c(938, 955), c(3022, 474), c(2482, 1183), c(3854, 923), c(376, 825), c(2519, 135), c(2945, 1622),
  c(953, 268), c(2628, 1479), c(2097, 981), c(890, 1846), c(2139, 1806), c(2421, 1007), c(2290, 1810), c(1115, 1052),
  c(2588, 302), c(327, 265), c(241, 341), c(1917, 687), c(2991, 792), c(2573, 599), c(19, 674), c(3911, 1673),
  c(872, 1559), c(2863, 558), c(929, 1766), c(839, 620), c(3893, 102), c(2178, 1619), c(3822, 899), c(378, 1048),
  c(1178, 100), c(2599, 901), c(3416, 143), c(2961, 1605), c(611, 1384), c(3113, 885), c(2597, 1830), c(2586, 1286),
  c(161, 906), c(1429, 134), c(742, 1025), c(1625, 1651), c(1187, 706), c(1787, 1009), c(22, 987), c(3640, 43),
  c(3756, 882), c(776, 392), c(1724, 1642), c(198, 1810), c(3950, 1558)
)

# Create points list
points <- list()
for (i in seq_along(raw_data)) {
  points[[i]] <- list(x = raw_data[[i]][1], y = raw_data[[i]][2], id = i)
}

# Run TSP algorithm
result <- tsp(points)
