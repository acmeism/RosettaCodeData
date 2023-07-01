class Node {
    construct new(v) {
        _v = v
        _left = null
        _right = null
    }

    value { _v }
    left  { _left }
    right { _right}

    left =(n)  { _left = n }
    right= (n) { _right = n }

    preOrder() {
        System.write(this)
        if (_left)  _left.preOrder()
        if (_right) _right.preOrder()
    }

    inOrder() {
        if ( _left) _left.inOrder()
        System.write(this)
        if (_right) _right.inOrder()
    }

    postOrder() {
        if (_left)  _left.postOrder()
        if (_right) _right.postOrder()
        System.write(this)
    }

    levelOrder() {
        var queue = [this]
        while (true) {
            var node = queue.removeAt(0)
            System.write(node)
            if (node.left)  queue.add(node.left)
            if (node.right) queue.add(node.right)
            if (queue.isEmpty) break
        }
    }

    exec(name, f) {
        System.write(name)
        f.call(this)
        System.print()
    }

    toString { " %(_v)" }
}

var nodes = List.filled(10, null)
for (i in 0..9) nodes[i] = Node.new(i)
nodes[1].left  = nodes[2]
nodes[1].right = nodes[3]
nodes[2].left  = nodes[4]
nodes[2].right = nodes[5]
nodes[4].left  = nodes[7]
nodes[3].left  = nodes[6]
nodes[6].left  = nodes[8]
nodes[6].right = nodes[9]

nodes[1].exec("   preOrder:", Fn.new { |n| n.preOrder()   })
nodes[1].exec("    inOrder:", Fn.new { |n| n.inOrder()    })
nodes[1].exec("  postOrder:", Fn.new { |n| n.postOrder()  })
nodes[1].exec("level-order:", Fn.new { |n| n.levelOrder() })
