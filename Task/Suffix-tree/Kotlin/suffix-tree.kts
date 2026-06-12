// version 1.1.3

class Node {
    var sub = ""                    // a substring of the input string
    var ch  = mutableListOf<Int>()  // list of child nodes
}

class SuffixTree(val str: String) {
    val nodes = mutableListOf<Node>(Node())

    init {
        for (i in 0 until str.length) addSuffix(str.substring(i))
    }

    private fun addSuffix(suf: String) {
        var n = 0
        var i = 0
        while (i < suf.length) {
            val b  = suf[i]
            val children = nodes[n].ch
            var x2 = 0
            var n2: Int
            while (true) {
                if (x2 == children.size) {
                    // no matching child, remainder of suf becomes new node.
                    n2 = nodes.size
                    nodes.add(Node().apply { sub = suf.substring(i) } )
                    children.add(n2)
                    return
                }
                n2 = children[x2]
                if (nodes[n2].sub[0] == b) break
                x2++
            }
            // find prefix of remaining suffix in common with child
            val sub2 = nodes[n2].sub
            var j = 0
            while (j < sub2.length) {
                if (suf[i + j] != sub2[j]) {
                    // split n2
                    val n3 = n2
                    // new node for the part in common
                    n2 = nodes.size
                    nodes.add(Node().apply {
                        sub = sub2.substring(0, j)
                        ch.add(n3)
                    })
                    nodes[n3].sub = sub2.substring(j)  // old node loses the part in common
                    nodes[n].ch[x2] = n2
                    break  // continue down the tree
                }
                j++
            }
            i += j  // advance past part in common
            n = n2  // continue down the tree
        }
    }

    fun visualize() {
        if (nodes.isEmpty()) {
            println("<empty>")
            return
        }

        fun f(n: Int, pre: String) {
            val children = nodes[n].ch
            if (children.isEmpty()) {
                println("╴ ${nodes[n].sub}")
                return
            }
            println("┐ ${nodes[n].sub}")
            for (c in children.dropLast(1)) {
                print(pre + "├─")
                f(c, pre + "│ ")
            }
            print(pre + "└─")
            f(children.last(), pre + "  ")
        }

        f(0, "")
    }
}

fun main(args: Array<String>) {
    SuffixTree("banana$").visualize()
}
