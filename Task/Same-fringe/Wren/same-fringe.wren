import "/dynamic" for Struct

var Node = Struct.create("Node", ["key", "left", "right"])

// 'leaves' returns a fiber that yields the leaves of the tree
//  until all leaves have been received.
var leaves = Fn.new { |t|
    // recursive function to walk tree
    var f
    f = Fn.new { |n|
        if (!n) return
        // leaves are identified by having no children
        if (!n.left && !n.right) {
            Fiber.yield(n.key)
        } else {
            f.call(n.left)
            f.call(n.right)
        }
    }
    // return a fiber which walks the tree
    return Fiber.new { f.call(t) }
}

var sameFringe = Fn.new { |t1, t2|
    var f1 = leaves.call(t1)
    var f2 = leaves.call(t2)
    var l1
    while (l1 = f1.call()) {
        // both trees must yield a leaf, and the leaves must be equal
        var l2
        if ((l2 = f2.call()) && (!l2 || l1 != l2)) return false
    }
    // there must be nothing left in f2 after consuming all of f1
    return !f2.call()
}

// the different shapes of the trees is shown with indention,
// the leaves being easy to spot by the key
var t1 = Node.new(3,
             Node.new(1,
                 Node.new(1, null, null),
                 Node.new(2, null, null)
             ),
             Node.new(8,
                 Node.new(5, null, null),
                 Node.new(13, null, null)
             )
         )
// t2 with negative values for internal nodes that can't possibly match
// positive values in t1, just to show that only leaves are being compared.
var t2 = Node.new(-8,
             Node.new(-3,
                 Node.new(-1,
                     Node.new(1, null, null),
                     Node.new(2, null, null)
                 ),
                 Node.new(5, null,null)
             ),
             Node.new(13, null, null)
         )
// t3 as t2 but with a different leave
var t3 = Node.new(-8,
             Node.new(-3,
                 Node.new(-1,
                     Node.new(1, null, null),
                     Node.new(2, null, null)
                 ),
                 Node.new(5, null,null)
             ),
             Node.new(14, null, null) // 14 instead of 13
         )
System.print("tree 1 and tree 2 have the same leaves: %(sameFringe.call(t1, t2))")
System.print("tree 1 and tree 3 have the same leaves: %(sameFringe.call(t1, t3))")
System.print("tree 2 and tree 3 have the same leaves: %(sameFringe.call(t2, t3))")
