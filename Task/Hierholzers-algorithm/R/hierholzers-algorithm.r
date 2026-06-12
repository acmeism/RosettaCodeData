# Function to print the Eulerian circuit
print_circuit <- function(adj) {
  if (length(adj) == 0) {
    return() # If the adjacency list is empty, do nothing
  }

  curr_path <- c(1) # Start with vertex 1 (R uses 1-based indexing)
  circuit <- c()

  while (length(curr_path) > 0) {
    curr_v <- curr_path[length(curr_path)] # Get the last element of curr_path

    if (length(adj[[curr_v]]) > 0) {
      next_v <- adj[[curr_v]][1] # Get next vertex from list
      adj[[curr_v]] <- adj[[curr_v]][-1] # Remove the used vertex
      curr_path <- c(curr_path, next_v) # Append the new vertex to curr_path
    } else {
      # Backtrack and add to the circuit
      circuit <- c(circuit, curr_path[length(curr_path)])
      curr_path <- curr_path[-length(curr_path)]
    }
  }

  # Print the circuit in reverse order
  for (i in seq_along(circuit)) {
    cat(circuit[length(circuit) - i + 1])
    if (i < length(circuit)) {
      cat(" -> ")
    }
  }
  cat("\n")
}

# Testing code
adj1 <- list()
adj2 <- list()

# First adjacency list
adj1[[1]] <- c(2) # Note: R uses 1-based indexing
adj1[[2]] <- c(3)
adj1[[3]] <- c(1)
print_circuit(adj1)

# Second adjacency list
adj2[[1]] <- c(2, 7)
adj2[[2]] <- c(3)
adj2[[3]] <- c(1, 4)
adj2[[4]] <- c(5)
adj2[[5]] <- c(3, 6)
adj2[[6]] <- c(5)
adj2[[7]] <- c(1)
print_circuit(adj2)

