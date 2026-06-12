import java.util.*

class BlossomMatching(private val adj: List<List<Int>>) {
    private val n = adj.size
    private val match = IntArray(n) { -1 }
    private val p = IntArray(n)
    private val base = IntArray(n)
    private val used = BooleanArray(n)
    private val blossom = BooleanArray(n)
    private val queue = ArrayDeque<Int>()

    // Find least common ancestor of a and b in the alternating forest
    private fun lca(a: Int, b: Int): Int {
        val usedPath = BooleanArray(n)
        var currentA = a

        while (true) {
            currentA = base[currentA]
            usedPath[currentA] = true
            if (match[currentA] < 0) break
            currentA = p[match[currentA]]
        }

        var currentB = b
        while (true) {
            currentB = base[currentB]
            if (usedPath[currentB]) return currentB
            currentB = p[match[currentB]]
        }
    }

    // Mark vertices along the path from v to base b, setting their parent to x
    private fun markPath(v: Int, b: Int, x: Int) {
        var currentV = v
        var currentX = x

        while (base[currentV] != b) {
            val mv = match[currentV]
            blossom[base[currentV]] = true
            blossom[base[mv]] = true
            p[currentV] = currentX
            currentX = mv
            currentV = p[currentX]
        }
    }

    // Try to find an augmenting path starting from root
    private fun findPath(root: Int): Boolean {
        used.fill(false)
        p.fill(-1)
        for (i in 0 until n) {
            base[i] = i
        }
        queue.clear()

        used[root] = true
        queue.add(root)

        while (queue.isNotEmpty()) {
            val v = queue.poll()
            for (u in adj[v]) {
                if (base[v] == base[u] || match[v] == u) {
                    continue
                }

                // Blossom found
                if (u == root || (match[u] >= 0 && p[match[u]] >= 0)) {
                    val curbase = lca(v, u)
                    blossom.fill(false)
                    markPath(v, curbase, u)
                    markPath(u, curbase, v)

                    for (i in 0 until n) {
                        if (blossom[base[i]]) {
                            base[i] = curbase
                            if (!used[i]) {
                                used[i] = true
                                queue.add(i)
                            }
                        }
                    }
                } else if (p[u] < 0) {
                    // Extend the alternating tree
                    p[u] = v

                    // Found augmenting path
                    if (match[u] < 0) {
                        var cur = u
                        while (cur >= 0) {
                            val prev = p[cur]
                            val next = if (prev >= 0) match[prev] else -1
                            match[cur] = prev
                            if (prev >= 0) match[prev] = cur
                            cur = next
                        }
                        return true
                    }

                    // Continue BFS from the matched partner
                    val mu = match[u]
                    if (!used[mu]) {
                        used[mu] = true
                        queue.add(mu)
                    }
                }
            }
        }
        return false
    }

    // Compute maximum matching; returns the size
    fun solve(): Int {
        var res = 0
        for (v in 0 until n) {
            if (match[v] < 0) {
                if (findPath(v)) {
                    res++
                }
            }
        }
        return res
    }

    fun getMatch(): IntArray = match.clone()
}

fun main() {
    // Example: 5-cycle (odd cycle) 0–1–2–3–4–0
    val n = 5
    val edges = arrayOf(
        intArrayOf(0, 1),
        intArrayOf(1, 2),
        intArrayOf(2, 3),
        intArrayOf(3, 4),
        intArrayOf(4, 0)
    )

    val adj = List(n) { mutableListOf<Int>() }
    for (edge in edges) {
        adj[edge[0]].add(edge[1])
        adj[edge[1]].add(edge[0])
    }

    val blossom = BlossomMatching(adj)
    val msize = blossom.solve()
    val match = blossom.getMatch()

    println("Maximum matching size: $msize")
    println("Matched pairs:")
    for (u in 0 until n) {
        val v = match[u]
        if (v >= 0 && u < v) {
            println("  $u – $v")
        }
    }
}
