class Node {
    construct new() {
        _sub = ""  // a substring of the input string
        _ch  = []  // list of child nodes
    }

    sub { _sub }
    ch  { _ch  }

    sub=(s) { _sub = s }
}

class SuffixTree {
    construct new(str) {
        _nodes = [Node.new()]
        for (i in 0...str.count) addSuffix_(str[i..-1])
    }

    addSuffix_(suf) {
        var n = 0
        var i = 0
        while (i < suf.count) {
            var b  = suf[i]
            var children = _nodes[n].ch
            var x2 = 0
            var n2
            while (true) {
                if (x2 == children.count) {
                    // no matching child, remainder of suf becomes new node.
                    n2 = _nodes.count
                    var nd = Node.new()
                    nd.sub = suf[i..-1]
                    _nodes.add(nd)
                    children.add(n2)
                    return
                }
                n2 = children[x2]
                if (_nodes[n2].sub[0] == b) break
                x2 = x2 + 1
            }
            // find prefix of remaining suffix in common with child
            var sub2 = _nodes[n2].sub
            var j = 0
            while (j < sub2.count) {
                if (suf[i + j] != sub2[j]) {
                    // split n2
                    var n3 = n2
                    // new node for the part in common
                    n2 = _nodes.count
                    var nd = Node.new()
                    nd.sub = sub2[0...j]
                    nd.ch.add(n3)
                    _nodes.add(nd)
                    _nodes[n3].sub = sub2[j..-1]  // old node loses the part in common
                    _nodes[n].ch[x2] = n2
                    break  // continue down the tree
                }
                j = j + 1
            }
            i = i + j  // advance past part in common
            n = n2     // continue down the tree
        }
    }

    visualize() {
        if (_nodes.isEmpty) {
            System.print("<empty>")
            return
        }

        var f // recursive closure
        f = Fn.new { |n, pre|
            var children = _nodes[n].ch
            if (children.isEmpty) {
                System.print("╴ %(_nodes[n].sub)")
                return
            }
            System.print("┐ %(_nodes[n].sub)")
            for (c in children[0...-1]) {
                System.write(pre + "├─")
                f.call(c, pre + "│ ")
            }
            System.write(pre + "└─")
            f.call(children[-1], pre + "  ")
        }

        f.call(0, "")
    }
}

SuffixTree.new("banana$").visualize()
