// version 1.1.3

import java.util.Stack

typealias Nodes = List<Node>

class Node(val n: Int) {
    var index   = -1  // -1 signifies undefined
    var lowLink = -1
    var onStack = false

    override fun toString()  = n.toString()
}

class DirectedGraph(val vs: Nodes, val es: Map<Node, Nodes>)

fun tarjan(g: DirectedGraph): List<Nodes> {
    val sccs = mutableListOf<Nodes>()
    var index = 0
    val s = Stack<Node>()

    fun strongConnect(v: Node) {
        // Set the depth index for v to the smallest unused index
        v.index = index
        v.lowLink = index
        index++
        s.push(v)
        v.onStack = true

        // consider successors of v
        for (w in g.es[v]!!) {
            if (w.index < 0) {
                // Successor w has not yet been visited; recurse on it
                strongConnect(w)
                v.lowLink = minOf(v.lowLink, w.lowLink)
            }
            else if (w.onStack) {
                // Successor w is in stack s and hence in the current SCC
                v.lowLink = minOf(v.lowLink, w.index)
            }
        }

        // If v is a root node, pop the stack and generate an SCC
        if (v.lowLink == v.index) {
            val scc = mutableListOf<Node>()
            do {
                val w = s.pop()
                w.onStack = false
                scc.add(w)
            }
            while (w != v)
            sccs.add(scc)
        }
    }

    for (v in g.vs) if (v.index < 0) strongConnect(v)
    return sccs
}

fun main(args: Array<String>) {
    val vs = (0..7).map { Node(it) }
    val es = mapOf(
        vs[0] to listOf(vs[1]),
        vs[2] to listOf(vs[0]),
        vs[5] to listOf(vs[2], vs[6]),
        vs[6] to listOf(vs[5]),
        vs[1] to listOf(vs[2]),
        vs[3] to listOf(vs[1], vs[2], vs[4]),
        vs[4] to listOf(vs[5], vs[3]),
        vs[7] to listOf(vs[4], vs[7], vs[6])
    )
    val g = DirectedGraph(vs, es)
    val sccs = tarjan(g)
    println(sccs.joinToString("\n"))
}
