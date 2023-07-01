import std.stdio, std.typecons, std.algorithm, std.container;

alias Vertex = string;
alias Weight = int;

struct Neighbor {
    Vertex target;
    Weight weight;
}

alias AdjacencyMap = Neighbor[][Vertex];

pure dijkstraComputePaths(Vertex source, Vertex target, AdjacencyMap adjacencyMap){
    Weight[Vertex] minDistance;
    Vertex[Vertex] previous;

    foreach(v, neighs; adjacencyMap){
        minDistance[v] = Weight.max;
        foreach(n; neighs) minDistance[n.target] = Weight.max;
    }

    minDistance[source] = 0;
    auto vertexQueue = redBlackTree(tuple(minDistance[source], source));

    foreach(_, u; vertexQueue){
        if (u == target)
            break;

        // Visit each edge exiting u.
        foreach(n; adjacencyMap.get(u, null)){
            const v = n.target;
            const distanceThroughU = minDistance[u] + n.weight;
            if(distanceThroughU < minDistance[v]){
                vertexQueue.removeKey(tuple(minDistance[v], v));
                minDistance[v] = distanceThroughU;
                previous[v] = u;
                vertexQueue.insert(tuple(minDistance[v], v));
            }
        }
    }

    return tuple(minDistance, previous);
}

pure dijkstraGetShortestPathTo(Vertex v, Vertex[Vertex] previous){
    Vertex[] path = [v];

    while (v in previous) {
        v = previous[v];
        if (v == path[$ - 1])
            break;
        path ~= v;
    }

    path.reverse();
    return path;
}

void main() {
    immutable arcs = [tuple("a", "b", 7),
                      tuple("a", "c", 9),
                      tuple("a", "f", 14),
                      tuple("b", "c", 10),
                      tuple("b", "d", 15),
                      tuple("c", "d", 11),
                      tuple("c", "f", 2),
                      tuple("d", "e", 6),
                      tuple("e", "f", 9)];

    AdjacencyMap adj;
    foreach (immutable arc; arcs) {
        adj[arc[0]] ~= Neighbor(arc[1], arc[2]);
        // Add this if you want an undirected graph:
        //adj[arc[1]] ~= Neighbor(arc[0], arc[2]);
    }

    const minDist_prev = dijkstraComputePaths("a", "e", adj);
    const minDistance = minDist_prev[0];
    const previous = minDist_prev[1];

    writeln(`Distance from "a" to "e": `, minDistance["e"]);
    writeln("Path: ", dijkstraGetShortestPathTo("e", previous));
}
