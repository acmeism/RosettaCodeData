# Define a constant for infinity
INF <- .Machine$double.xmax

# Function to perform Bellman-Ford algorithm
bellman_ford <- function(augmented_vertex_count, edges, source_vertex) {
  distances <- rep(INF, augmented_vertex_count)
  distances[source_vertex] <- 0  # R uses 1-based indexing

  # Relax edges repeatedly
  for (i in 1:(augmented_vertex_count - 1)) {
    for (j in 1:nrow(edges)) {
      u <- edges[j, 1]
      v <- edges[j, 2]
      weight <- edges[j, 3]
      if (distances[u] != INF && distances[u] + weight < distances[v]) {
        distances[v] <- distances[u] + weight
      }
    }
  }

  # Check for negative-weight cycles
  for (j in 1:nrow(edges)) {
    u <- edges[j, 1]
    v <- edges[j, 2]
    weight <- edges[j, 3]
    if (distances[u] != INF && distances[u] + weight < distances[v]) {
      return(list())  # Indicates a negative cycle
    }
  }

  return(distances)
}

# Function to perform Dijkstra's algorithm
dijkstra <- function(vertex_count, adjacency_list, source_vertex, h_values) {
  distances <- rep(INF, vertex_count)
  distances[source_vertex] <- 0
  priority_queue <- list(list(vertex = source_vertex, weight = 0))

  while (length(priority_queue) > 0) {
    # Extract min
    priority_queue <- priority_queue[order(sapply(priority_queue, function(x) x$weight))]
    current <- priority_queue[[1]]
    priority_queue <- priority_queue[-1]

    u <- current$vertex

    if (current$weight > distances[u]) {
      next
    }

    for (edge in adjacency_list[[u]]) {
      v <- edge[1]
      weight <- edge[2]
      if (distances[u] != INF && distances[u] + weight < distances[v]) {
        distances[v] <- distances[u] + weight
        priority_queue <- append(priority_queue, list(list(vertex = v, weight = distances[v])))
      }
    }
  }

  # Adjust distances
  final_distances <- rep(INF, vertex_count)
  for (i in 1:vertex_count) {
    if (distances[i] != INF) {
      final_distances[i] <- distances[i] - h_values[source_vertex] + h_values[i]
    }
  }

  return(final_distances)
}

# Main function to perform Johnson's algorithm
johnsons_algorithm <- function(graph) {
  vertex_count <- nrow(graph)
  original_edges <- matrix(nrow = 0, ncol = 3)

  # Step 0: Build a list of edges for the original graph
  for (i in 1:vertex_count) {
    for (j in 1:vertex_count) {
      weight <- graph[i, j]
      if (i != j && weight != INF) {
        original_edges <- rbind(original_edges, c(i, j, weight))
      }
    }
  }

  # Step 1: Form the augmented graph
  augmented_edges <- rbind(original_edges, cbind(vertex_count + 1, 1:vertex_count, rep(0, vertex_count)))

  # Step 2: Invoke the Bellman-Ford Algorithm
  h_values <- bellman_ford(vertex_count + 1, augmented_edges, vertex_count + 1)

  if (length(h_values) == 0) {
    return("A negative cycle was detected in the graph.")
  }

  h_values <- h_values[-length(h_values)]  # Remove the value for the augmented vertex

  # Step 3: Reweight the edges
  adjacency_list <- vector("list", vertex_count)
  for (i in 1:nrow(original_edges)) {
    u <- original_edges[i, 1]
    v <- original_edges[i, 2]
    weight <- original_edges[i, 3]
    reweight <- weight + h_values[u] - h_values[v]
    adjacency_list[[u]] <- append(adjacency_list[[u]], list(c(v, reweight)))
  }

  # Step 4: Invoke Dijkstra's Algorithm for each vertex
  all_pairs_shortest_paths <- list()
  for (u in 1:vertex_count) {
    all_pairs_shortest_paths[[u]] <- dijkstra(vertex_count, adjacency_list, u, h_values)
  }

  return(all_pairs_shortest_paths)
}

# Example usage
graph <- matrix(c(0, -5, 2, 3,
                  INF, 0, 4, INF,
                  INF, INF, 0, 1,
                  INF, INF, INF, 0), nrow = 4, byrow = TRUE)

result <- johnsons_algorithm(graph)
if (is.list(result)) {
  print("All pairs shortest paths:")
  for (i in 1:length(result)) {
    print(result[[i]])
  }
} else {
  print(result)
}

