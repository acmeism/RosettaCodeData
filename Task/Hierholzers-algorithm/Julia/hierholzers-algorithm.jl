""" Function to print the Eulerian circuit """
function print_circuit(adj)
    isempty(adj) && return # If the adjacency list is empty, do nothing
    curr_path = [0] # Start with vertex 0
    circuit = Int[]

    while !isempty(curr_path)
        curr_v = curr_path[end]
        if !isempty(adj[begin + curr_v])
            next_v = popfirst!(adj[begin + curr_v]) # Get next vertex from list
            push!(curr_path, next_v) # Push the new vertex to curr_path stack
        else
            # Backtrack and add to the circuit
            push!(circuit, pop!(curr_path))
        end
    end

    # Print the circuit in reverse order
    for i in length(circuit):-1:1
        print(circuit[i])
        i > 1 && print(" -> ")
    end
    println()
end

# testing code
const adj1, adj2 = Vector{Vector{Int}}(), Vector{Vector{Int}}()
# First adjacency list
push!(adj1, [1], [2], [0])
print_circuit(adj1)

# Second adjacency list
push!(adj2, [1, 6], [2], [0, 3], [4], [2, 5], [0], [4])
print_circuit(adj2)
