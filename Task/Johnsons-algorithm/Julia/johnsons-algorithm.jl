using Graphs

const edges = [(1, 2), (1, 3), (1, 4), (2, 3), (3, 4)]
const weights = [Inf -5.0 2.0 3.0; Inf 0.0 4.0 Inf; Inf Inf 0.0 1.0; Inf Inf Inf 0.0]

g = SimpleGraph(4) # 4 vertices
for (v1, v2) in edges # edge vertices are from a one-based vertex array
    add_edge!(g, v1, v2)
end

johnson_state = johnson_shortest_paths(g, weights)
display(johnson_state.dists)
