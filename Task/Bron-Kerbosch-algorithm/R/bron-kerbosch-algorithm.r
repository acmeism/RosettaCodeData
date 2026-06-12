# Global variable to store cliques
cliques <- list()

# Function to print a vector (sorted)
print_vector <- function(vec) {
  cat("[", paste(sort(as.character(vec)), collapse = ", "), "]", sep = "")
}

# Function to print a list of vectors
print_2D_vector <- function(vecs) {
  cat("[")
  n <- length(vecs)
  for (i in seq_len(n)) {
    print_vector(vecs[[i]])
    if (i < n) cat(", ")
  }
  cat("]\n")
}

# Bron-Kerbosch algorithm implementation
bron_kerbosch <- function(current_clique, candidates, processed_vertices, graph) {
  # Access the global 'cliques' variable
  cliques <<- cliques

  # Base case: if both candidates and processed are empty, we have a maximal clique
  if (length(candidates) == 0 && length(processed_vertices) == 0) {
    if (length(current_clique) > 2) {
      cliques <<- append(cliques, list(sort(current_clique)))
    }
    return()
  }

  # Union of candidates and processed vertices
  union_set <- unique(c(candidates, processed_vertices))

  # Choose pivot with maximum degree
  pivot <- union_set[which.max(sapply(union_set, function(v) length(graph[[v]])))]

  # Possibles: candidates not adjacent to pivot
  possibles <- setdiff(candidates, graph[[pivot]])

  # Iterate over each possible vertex
  for (vertex in possibles) {
    # Neighbors of vertex
    neighbors <- graph[[vertex]]

    # Intersect candidates and processed with neighbors
    new_candidates <- intersect(candidates, neighbors)
    new_processed_vertices <- intersect(processed_vertices, neighbors)

    # Recursive call with updated sets (don't modify original sets)
    bron_kerbosch(c(current_clique, vertex), new_candidates, new_processed_vertices, graph)
  }
}

# Main function
main <- function() {
  # Clear global cliques
  cliques <<- list()

  # Define edges (as character pairs)
  edges <- list(
    c("a", "b"), c("b", "a"), c("a", "c"), c("c", "a"),
    c("b", "c"), c("c", "b"), c("d", "e"), c("e", "d"),
    c("d", "f"), c("f", "d"), c("e", "f"), c("f", "e")
  )

  # Build graph as adjacency list
  graph <- list()
  nodes <- unique(unlist(edges))
  for (node in nodes) {
    graph[[node]] <- c()
  }

  for (edge in edges) {
    start <- edge[1]
    end <- edge[2]
    if (!(end %in% graph[[start]])) {
      graph[[start]] <- c(graph[[start]], end)
    }
  }

  # Initialize Bron-Kerbosch parameters
  current_clique <- c()
  candidates <- names(graph)
  processed_vertices <- c()

  # Run Bron-Kerbosch
  bron_kerbosch(current_clique, candidates, processed_vertices, graph)

  # Remove duplicates and sort cliques by size and content
  unique_cliques <- unique(lapply(cliques, sort))
  cliques <<- unique_cliques[order(sapply(unique_cliques, length), sapply(unique_cliques, function(x) paste(sort(x), collapse = ",")))]

  # Print result
  print_2D_vector(cliques)
}

# Run main
main()
