// version 1.1.4

class Node {
    val edges = mutableMapOf<Char, Node>()  // edges (or forward links)
    var link: Node? = null                  // suffix link (backward links)
    var len = 0                             // the length of the node
}

class Eertree(str: String) {
    val nodes = mutableListOf<Node>()

    private val rto = Node()                // odd length root node, or node -1
    private val rte = Node()                // even length root node, or node 0
    private val s = StringBuilder("0")      // accumulated input string, T = S[1..i]
    private var maxSufT = rte               // maximum suffix of tree T

    init {
        // Initialize and build the tree
        rte.link = rto
        rto.link = rte
        rto.len  = -1
        rte.len  = 0
        for (ch in str) add(ch)
    }

    private fun getMaxSuffixPal(startNode: Node, a: Char): Node {
        // We traverse the suffix-palindromes of T in the order of decreasing length.
        // For each palindrome we read its length k and compare T[i-k] against a
        // until we get an equality or arrive at the -1 node.
        var u = startNode
        val i = s.length
        var k = u.len
        while (u !== rto && s[i - k - 1] != a) {
            if (u === u.link!!) throw RuntimeException("Infinite loop detected")
            u = u.link!!
            k = u.len
        }
        return u
    }

    private fun add(a: Char): Boolean {
        // We need to find the maximum suffix-palindrome P of Ta
        // Start by finding maximum suffix-palindrome Q of T.
        // To do this, we traverse the suffix-palindromes of T
        // in the order of decreasing length, starting with maxSuf(T)
        val q = getMaxSuffixPal(maxSufT, a)

        // We check Q to see whether it has an outgoing edge labeled by a.
        val createANewNode = a !in q.edges.keys

        if (createANewNode) {
            // We create the node P of length Q + 2
            val p = Node()
            nodes.add(p)
            p.len = q.len + 2
            if (p.len == 1) {
                // if P = a, create the suffix link (P, 0)
                p.link = rte
            }
            else {
                // It remains to create the suffix link from P if |P|>1. Just
                // continue traversing suffix-palindromes of T starting with the
                // the suffix link of Q.
                p.link = getMaxSuffixPal(q.link!!, a).edges[a]
            }

            // create the edge (Q, P)
            q.edges[a] = p
        }

        // P becomes the new maxSufT
        maxSufT = q.edges[a]!!

        // Store accumulated input string
        s.append(a)

        return createANewNode
    }

    fun getSubPalindromes(): List<String> {
        // Traverse tree to find sub-palindromes
        val result = mutableListOf<String>()
        // Odd length words
        getSubPalindromes(rto, listOf(rto), "", result)
        // Even length words
        getSubPalindromes(rte, listOf(rte), "", result)
        return result
    }

    private fun getSubPalindromes(nd: Node, nodesToHere: List<Node>,
                          charsToHere: String, result: MutableList<String>) {
        // Each node represents a palindrome, which can be reconstructed
        // by the path from the root node to each non-root node.

        // Traverse all edges, since they represent other palindromes
        for ((lnkName, nd2) in nd.edges) {
            getSubPalindromes(nd2, nodesToHere + nd2, charsToHere + lnkName, result)
        }

        // Reconstruct based on charsToHere characters.
        if (nd !== rto && nd !== rte) { // Don't print for root nodes
            val assembled = charsToHere.reversed() +
                if (nodesToHere[0] === rte)  // Even string
                    charsToHere
                else  // Odd string
                    charsToHere.drop(1)
            result.add(assembled)
        }
    }
}

fun main(args: Array<String>) {
    val str = "eertree"
    println("Processing string '$str'")
    val eertree = Eertree(str)
    println("Number of sub-palindromes: ${eertree.nodes.size}")
    val result = eertree.getSubPalindromes()
    println("Sub-palindromes: $result")
}
