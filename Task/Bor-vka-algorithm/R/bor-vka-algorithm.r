# Structure to represent a graph
Graph <- function(vertices) {
  list(
    v = vertices,  # Number of vertices
    graph = list()  # List of Edges (list of vectors: [u, v, weight])
  )
}

# Function to add an edge to the graph with adjust for basis (1 vs 0) of vertex array
add_edge <- function(g, u, v, wt, adjust = TRUE) {
  g$graph[[length(g$graph) + 1]] <- c(u + adjust, v + adjust, wt)
  return(g)
}

# A utility function to find the set of an element i (uses path compression technique)
find_set <- function(parent, i) {
  if (parent[i] == i) {
    return(list(result = i, parent = parent))
  }
  result <- find_set(parent, parent[i])
  parent <- result$parent
  parent[i] <- result$result  # Path compression
  return(list(result = result$result, parent = parent))
}

# A function that performs union by rank of two sets x and y
union_set <- function(parent, rank, x, y) {
  x_root <- find_set(parent, x)
  parent <- x_root$parent
  x_root <- x_root$result

  y_root <- find_set(parent, y)
  parent <- y_root$parent
  y_root <- y_root$result

  # Attach smaller rank tree under root of high rank tree
  if (rank[x_root] < rank[y_root]) {
    parent[x_root] <- y_root
  } else if (rank[x_root] > rank[y_root]) {
    parent[y_root] <- x_root
  } else {
    # If ranks are the same, make one as root and increment its rank
    parent[y_root] <- x_root
    rank[x_root] <- rank[x_root] + 1
  }

  return(list(parent = parent, rank = rank))
}

# The main function to construct MST using Boruvka's algorithm
boruvka_mst <- function(g, adjust = TRUE) {
  parent <- 1:g$v
  rank <- rep(0, g$v)

  # Initially there are V different trees
  # Finally there will be one tree that will be the MST
  num_trees <- g$v
  mst_weight <- 0

  # Keep combining components (or sets) until all
  # components are combined into a single MST
  while (num_trees > 1) {
    # An array to store the index of the cheapest edge of each subset
    # It stores [u, v, w] for each component
    cheapest <- replicate(g$v, c(-1, -1, -1), simplify = FALSE)

    # Traverse through all edges and update
    # cheapest edge for every component
    for (edge in g$graph) {
      u <- edge[1]
      v <- edge[2]
      w <- edge[3]

      set1_result <- find_set(parent, u)
      parent <- set1_result$parent
      set1 <- set1_result$result

      set2_result <- find_set(parent, v)
      parent <- set2_result$parent
      set2 <- set2_result$result

      # If two corners of current edge belong to different sets,
      # check if current edge is cheaper than previous cheapest edges
      if (set1 != set2) {
        if (cheapest[[set1]][3] == -1 || cheapest[[set1]][3] > w) {
          cheapest[[set1]] <- c(u, v, w)
        }
        if (cheapest[[set2]][3] == -1 || cheapest[[set2]][3] > w) {
          cheapest[[set2]] <- c(u, v, w)
        }
      }
    }

    # Consider the picked cheapest edges and add them to the MST
    for (vtx in 1:g$v) {
      # Check if cheapest edge for current set exists
      if (cheapest[[vtx]][3] != -1) {
        u <- cheapest[[vtx]][1]
        v <- cheapest[[vtx]][2]
        w <- cheapest[[vtx]][3]

        set1_result <- find_set(parent, u)
        parent <- set1_result$parent
        set1 <- set1_result$result

        set2_result <- find_set(parent, v)
        parent <- set2_result$parent
        set2 <- set2_result$result

        if (set1 != set2) {
          mst_weight <- mst_weight + w
          union_result <- union_set(parent, rank, set1, set2)
          parent <- union_result$parent
          rank <- union_result$rank
          # adjust vertex numbers in output to match original edge array basis of 0
          cat(sprintf("Edge %d->%d with weight %d is included in MST\n",
                      u - adjust, v - adjust, w))
          num_trees <- num_trees - 1
        }
      }
    }
  }
  cat("Weight of MST is", mst_weight, "\n")
}

# Test function
test_mst <- function() {
  g <- Graph(4)
  g <- add_edge(g, 0, 1, 10)
  g <- add_edge(g, 0, 2, 6)
  g <- add_edge(g, 0, 3, 5)
  g <- add_edge(g, 1, 3, 15)
  g <- add_edge(g, 2, 3, 4)
  boruvka_mst(g)
}

# Run the test
test_mst()
