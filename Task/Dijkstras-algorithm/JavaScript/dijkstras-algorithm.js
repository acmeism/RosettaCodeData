const dijkstra = (edges,source,target) => {
    const Q = new Set(),
          prev = {},
          dist = {},
          adj = {}

    const vertex_with_min_dist = (Q,dist) => {
        let min_distance = Infinity,
            u = null

        for (let v of Q) {
            if (dist[v] < min_distance) {
                min_distance = dist[v]
                u = v
            }
        }
        return u
    }

    for (let i=0;i<edges.length;i++) {
        let v1 = edges[i][0],
            v2 = edges[i][1],
            len = edges[i][2]

        Q.add(v1)
        Q.add(v2)

        dist[v1] = Infinity
        dist[v2] = Infinity

        if (adj[v1] === undefined) adj[v1] = {}
        if (adj[v2] === undefined) adj[v2] = {}

        adj[v1][v2] = len
        adj[v2][v1] = len
    }

    dist[source] = 0

    while (Q.size) {
        let u = vertex_with_min_dist(Q,dist),
            neighbors = Object.keys(adj[u]).filter(v=>Q.has(v)) //Neighbor still in Q

        Q.delete(u)

        if (u===target) break //Break when the target has been found

        for (let v of neighbors) {
            let alt = dist[u] + adj[u][v]
            if (alt < dist[v]) {
                dist[v] = alt
                prev[v] = u
            }
        }
    }

    {
        let u = target,
        S = [u],
        len = 0

        while (prev[u] !== undefined) {
            S.unshift(prev[u])
            len += adj[u][prev[u]]
            u = prev[u]
        }
        return [S,len]
    }
}

//Testing algorithm
let graph = []
graph.push(["a", "b", 7])
graph.push(["a", "c", 9])
graph.push(["a", "f", 14])
graph.push(["b", "c", 10])
graph.push(["b", "d", 15])
graph.push(["c", "d", 11])
graph.push(["c", "f", 2])
graph.push(["d", "e", 6])
graph.push(["e", "f", 9])

let [path,length] = dijkstra(graph, "a", "e");
console.log(path) //[ 'a', 'c', 'f', 'e' ]
console.log(length) //20
