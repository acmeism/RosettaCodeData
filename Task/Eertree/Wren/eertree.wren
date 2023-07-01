class Node {
    construct new() {
        _edges = {}    // edges (or forward links)
        _link = null   // suffix link (backward links)
        _len = 0       // the length of the node
    }

    edges    { _edges }
    link     { _link }
    link=(l) { _link = l }
    len      { _len }
    len=(l)  { _len = l }
}

class Eertree {
    construct new(str) {
        _nodes = []
        _rto = Node.new()  // odd length root node, or node -1
        _rte = Node.new()  // even length root node, or node 0
        _s = "0"           // accumulated input string, T = S[1..i]
        _maxSufT = _rte    // maximum suffix of tree T

        // Initialize and build the tree
        _rte.link = _rto
        _rto.link = _rte
        _rto.len  = -1
        _rte.len  = 0
        for (ch in str) add_(ch)
    }

    nodes { _nodes }

    getMaxSuffixPal_(startNode, a) {
        // We traverse the suffix-palindromes of T in the order of decreasing length.
        // For each palindrome we read its length k and compare T[i-k] against a
        // until we get an equality or arrive at the -1 node.
        var u = startNode
        var i = _s.count
        var k = u.len
        while (u != _rto && _s[i - k - 1] != a) {
            if (u == u.link) Fiber.abort("Infinite loop detected")
            u = u.link
            k = u.len
        }
        return u
    }

    add_(a) {
        // We need to find the maximum suffix-palindrome P of Ta
        // Start by finding maximum suffix-palindrome Q of T.
        // To do this, we traverse the suffix-palindromes of T
        // in the order of decreasing length, starting with maxSuf(T)
        var q = getMaxSuffixPal_(_maxSufT, a)
        // We check Q to see whether it has an outgoing edge labeled by a.
        var createANewNode = !q.edges.keys.contains(a)

        if (createANewNode) {
            // We create the node P of length Q + 2
            var p = Node.new()
            _nodes.add(p)
            p.len = q.len + 2
            if (p.len == 1) {
                // if P = a, create the suffix link (P, 0)
                p.link = _rte
            } else {
                // It remains to create the suffix link from P if |P|>1. Just
                // continue traversing suffix-palindromes of T starting with the
                // the suffix link of Q.
                p.link = getMaxSuffixPal_(q.link, a).edges[a]
            }

            // create the edge (Q, P)
            q.edges[a] = p
        }

        // P becomes the new maxSufT
        _maxSufT = q.edges[a]

        // Store accumulated input string
        _s = _s + a

        return createANewNode
    }

    getSubPalindromes() {
        // Traverse tree to find sub-palindromes
        var result = []
        // Odd length words
        getSubPalindromes_(_rto, [_rto], "", result)
        // Even length words
        getSubPalindromes_(_rte, [_rte], "", result)
        return result
    }

    getSubPalindromes_(nd, nodesToHere, charsToHere, result) {
        // Each node represents a palindrome, which can be reconstructed
        // by the path from the root node to each non-root node.

        // Traverse all edges, since they represent other palindromes
        for (lnkName in nd.edges.keys) {
            var nd2 = nd.edges[lnkName]
            getSubPalindromes_(nd2, nodesToHere + [nd2], charsToHere + lnkName, result)
        }

        // Reconstruct based on charsToHere characters.
        if (nd != _rto && nd != _rte) { // Don't print for root nodes
            var assembled = charsToHere[-1..0] +
                ((nodesToHere[0] == _rte) ? charsToHere : charsToHere[1..-1])
            result.add(assembled)
        }
    }
}

var str = "eertree"
System.print("Processing string '%(str)'")
var eertree = Eertree.new(str)
System.print("Number of sub-palindromes: %(eertree.nodes.count)")
var result = eertree.getSubPalindromes()
System.print("Sub-palindromes: %(result)")
