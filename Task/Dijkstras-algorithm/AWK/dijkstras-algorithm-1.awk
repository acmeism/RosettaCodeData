NF == 3 { graph[$1,$2] = $3 }
NF == 2 {
    weight = shortest($1, $2)
    n = length(path)
    p = $1
    for (i = 2; i < n; i++)
        p = p "-" path[i]
    print p "-" $2 " (" weight ")"
}

# Edge weights are in graph[node1,node2]
# Returns the weight of the shortest path
# Shortest path is in path[1] ... path[n]
function shortest(from, to,    queue, q, dist, v, i, min, edge, e, prev, n) {
    delete path
    dist[from] = 0
    queue[q=1] = from

    while (q > 0) {
        min = 1
        for (i = 2; i <= q; i++)
            if (dist[queue[i]] < dist[queue[min]])
                min = i
        v = queue[min]
        queue[min] = queue[q--]

        if (v == to)
            break
        for (edge in graph) {
            split(edge, e, SUBSEP)
            if (e[1] != v)
                continue
            if (!(e[2] in dist) || dist[e[1]] + graph[edge] < dist[e[2]]) {
                dist[e[2]] = dist[e[1]] + graph[edge]
                prev[e[2]] = e[1]
                queue[++q] = e[2]
            }
        }
    }
    if (v != to)
        return "n/a"

    # Build the path
    n = 1
    for (v = to; v != from; v = prev[v])
        n++
    for (v = to; n > 0; v = prev[v])
       path[n--] = v
    return dist[to]
}
