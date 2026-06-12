import "./queue" for Deque
import "./set" for Set

/* Finds maximum matching in a general undirected graph using Edmonds' Blossom algorithm.
   Input: adj — list of lists, adj[u] is the list of neighbors of u (0-indexed).
   Returns: match, size
   match — list where match[u] = v if u–v is in the matching, or -1
   size  — number of matched edges
*/
var maxMatching = Fn.new { |adj|
    var n = adj.count
    var match = List.filled(n, -1)       // match[u] = v if u is matched to v
    var p = List.filled(n, -1)           // parent in the alternating tree
    var base = (0...n).toList            // base[u] = base vertex of blossom containing u
    var q = Deque.new()                  // queue for BFS
    var used = List.filled(n, false)     // whether vertex is in the tree
    var blossom = List.filled(n, false)  // helper array for marking blossoms

    // Find least common ancestor of a and b in the forest of alternating tree.
    var lca = Fn.new { |a, b|
        var usedPath = List.filled(n, false)
        while (true) {
            a = base[a]
            usedPath[a] = true
            if (match[a] == -1) break
            a = p[match[a]]
        }
        while (true) {
            b = base[b]
            if (usedPath[b]) return b
            b = p[match[b]]
        }
    }

    // Mark vertices along the path from v to base b, setting their parent to x.
    var markPath = Fn.new { |v, b, x|
        while (base[v] != b) {
            blossom[base[v]] = blossom[base[match[v]]] = true
            p[v] = x
            x = match[v]
            v = p[x]
        }
    }

    // Try to find an augmenting path starting from root.
    var findPath = Fn.new { |root|
        // reset
        used = List.filled(n, false)
        p = List.filled(n, -1)
        for (i in 0...n) base[i] = i
        q.clear()

        used[root] = true
        q.pushBack(root)

        while (!q.isEmpty) {
            var v = q.popFront()
            for (u in adj[v]) {
                // two cases to skip
                if (base[v] == base[u] || match[v] == u) continue
                // found a blossom or an odd cycle edge
                if (u == root || (match[u] != -1 && p[match[u]] != -1)) {
                    var curbase = lca.call(v, u)
                    blossom = List.filled(n, false)
                    markPath.call(v, curbase, u)
                    markPath.call(u, curbase, v)
                    // contract blossom
                    for (i in 0...n) {
                        if (blossom[base[i]]) {
                            base[i] = curbase
                            if (!used[i]) {
                                used[i] = true
                                q.pushBack(i)
                            }
                        }
                    }
                // otherwise extend the alternating tree
                } else if (p[u] == -1) {
                    p[u] = v
                    if (match[u] == -1) {
                        // augmenting path found: flip matches along the path
                        var curr = u
                        while (curr != -1) {
                            var prev = p[curr]
                            var next = (prev != -1) ? match[prev] : -1
                            match[curr] = prev
                            match[prev] = curr
                            curr = next
                        }
                        return true
                    }
                    // else continue BFS from the matched partner
                    used[match[u]] = true
                    q.pushBack(match[u])
                }
            }
        }
        return false
    }

    // Main loop: try to grow matching by finding augmenting paths.
    var res = 0
    for (v in 0...n) {
        if (match[v] == -1) {
            if (findPath.call(v)) res = res + 1
        }
    }
    return [match, res]
}

// Example: 5‑cycle (odd cycle)
// Vertices: 0–1–2–3–4–0
var n = 5
var edges = [ [0, 1], [1, 2], [2, 3], [3, 4], [4, 0] ]
var adj = List.filled(n, null)
for (i in 0...n) adj[i] = []
for (e in edges) {
    var u = e[0]
    var v = e[1]
    adj[u].add(v)
    adj[v].add(u)
}
var res = maxMatching.call(adj)
var match = res[0]
var msize = res[1]
System.print("Maximum matching size: %(msize)")
System.print("Matched pairs:")
var seen = Set.new()
var u = -1
for (v in match) {
    u = u + 1
    if (v != -1 && !seen.contains([v, u].toString)) {
        System.print("  %(u) – %(v)")
        seen.add([u, v].toString)
    }
}
