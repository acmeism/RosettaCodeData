var kosaraju = Fn.new { |g|
    var gc = g.count
    // 1. For each vertex u of the graph, mark u as unvisited. Let l be empty.
    var vis = List.filled(gc, false)
    var l = List.filled(gc, 0)
    var x = gc                     // index for filling l in reverse order
    var t = List.filled(gc, null)  // transpose graph
    for (i in 0...gc) t[i] = []
    var visit // recursive function
    visit = Fn.new { |u|
        if (!vis[u]) {
            vis[u] = true
            for (v in g[u]) {
                visit.call(v)
                t[v].add(u)  // construct transpose
            }
            x = x - 1
            l[x] = u
        }
    }
    // 2. For each vertex u of the graph do visit.call(u).
    for (i in 0...gc) visit.call(i)
    var c = List.filled(gc, 0) // result, the component assignment
    var assign // recursive function
    assign = Fn.new { |u, root|
        if (vis[u]) {  // repurpose vis to mean 'unassigned'
            vis[u] = false
            c[u] = root
            for (v in t[u]) assign.call(v, root)
        }
    }
    // 3: For each element u of l in order, do assign.call(u,u).
    for (u in l) assign.call(u, u)
    return c
}

var g = [ [1], [2], [0], [1, 2, 4], [3, 5], [2, 6], [5], [4, 6, 7] ]
System.print(kosaraju.call(g))
