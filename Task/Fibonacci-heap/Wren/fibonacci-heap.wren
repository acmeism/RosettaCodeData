import "./str" for Str

class Node {
    construct new(value) {
        _value  = value
        _parent = null
        _child  = null
        _prev   = null
        _next   = null
        _rank   = 0
        _mark   = false
    }

    value  { _value  }
    parent { _parent }
    child  { _child  }
    prev   { _prev   }
    next   { _next   }
    rank   { _rank   }
    mark   { _mark   }

    value=(v)  { _value = v  }
    parent=(p) { _parent = p }
    child=(c)  { _child = c  }
    prev=(p)   { _prev = p   }
    next=(n)   { _next = n   }
    rank=(r)   { _rank = r   }
    mark=(m)   { _mark = m   }

    meld1(node) {
        if (_prev) _prev.next = node
        node.prev = _prev
        node.next = this
        _prev = node
    }

    meld2(node) {
        if (_prev) _prev.next = node
        if (node.prev) node.prev.next = this
        var temp = _prev
        _prev = node.prev
        node.prev = temp
    }
}

class FibonacciHeap {
    construct new() {
        _node = null
    }

    construct new(node) {
        _node = node
    }

    node     { _node }
    node=(n) { _node = n }

    insert(v) {
        var x = Node.new(v)
        if (!_node) {
            x.next = x
            x.prev = x
            _node = x
        } else {
            _node.meld1(x)
            if (Str.lt(x.value, _node.value)) _node = x
        }
        return x
    }

    union(other) {
        if (!_node) {
            _node = other.node
        } else if (other.node) {
            _node.meld2(other.node)
            if (Str.lt(other.node.value, _node.value)) _node = other.node
        }
        other.node = null
    }

    minimum() { _node.value }

    extractMin() {
        if (!_node) return null
        var min = minimum()
        var roots = {}

        var add = Fn.new { |r|
            r.prev = r
            r.next = r
            var rr = r
            while (true) {
                var x = roots[rr.rank]
                if (!x) break
                roots.remove(rr.rank)
                if (Str.lt(x.value, rr.value)) {
                    var t = rr
                    rr = x
                    x = t
                }
                x.parent = rr
                x.mark = false
                if (!rr.child) {
                    x.next = x
                    x.prev = x
                    rr.child = x
                } else {
                    rr.child.meld1(x)
                }
                rr.rank = rr.rank + 1
            }
            roots[rr.rank] = rr
        }

        var r = _node.next
        while (r != _node) {
            var n = r.next
            add.call(r)
            r = n
        }
        var c = _node.child
        if (c) {
            c.parent = null
            var rr = c.next
            add.call(c)
            while (rr != c) {
                var n = rr.next
                rr.parent = null
                add.call(rr)
                rr = n
            }
        }
        if (roots.isEmpty) {
            _node = null
            return min
        }
        var d = roots.keys.toList[0]
        var mv = roots[d]
        roots.remove(d)
        mv.next = mv
        mv.prev = mv
        for (rr in roots.values) {
            rr.prev = mv
            rr.next = mv.next
            mv.next.prev = rr
            mv.next = rr
            if (Str.lt(rr.value, mv.value)) mv = rr
        }
        _node = mv
        return min
    }

    decreaseKey(n, v) {
        if (Str.le(n.value, v)) {
            Fiber.abort("In 'decreaseKey' new value greater than or equal to existing value.")
        }
        n.value = v
        if (n == _node) return
        var p = n.parent
        if (!p) {
            if (Str.lt(v, _node.value)) _node = n
            return
        }
        cutAndMeld_(n)
    }

    cut_(x) {
        var p = x.parent
        if (!p) return
        p.rank = p.rank - 1
        if (p.rank == 0) {
            p.child = null
        } else {
            p.child = x.next
            if (x.prev) x.prev.next = x.next
            if (x.next) x.next.prev = x.prev
        }
        if (!p.parent) return
        if (!p.mark) {
            p.mark = true
            return
        }
        cutAndMeld_(p)
    }

    cutAndMeld_(x) {
        cut_(x)
        x.parent = null
        if(_node) _node.meld1(x)
    }

    delete(n) {
        var p = n.parent
        if (!p) {
            if (n == _node) {
                extractMin()
                return
            }
            if (n.prev) n.prev.next = n.next
            if (n.next) n.next.prev = n.prev
        } else {
            cut_(n)
        }
        var c = n.child
        if (!c) return
        while (true) {
            c.parent = null
            c = c.next
            if (c == n.child) break
        }
        if (_node) _node.meld2(c)
    }

    visualize() {
        if (!_node) {
            System.print("<empty>")
            return
        }

        var f // recursive closure
        f = Fn.new { |n, pre|
            var pc = "│ "
            var x = n
            while (true) {
                if (x.next != n) {
                    System.write("%(pre)├─")
                } else {
                    System.write("%(pre)└─")
                    pc = "  "
                }
                if (!x.child) {
                    System.print("╴ %(x.value)")
                } else {
                    System.print("┐ %(x.value)")
                    f.call(x.child, pre + pc)
                }
                if (x.next == n) break
                x = x.next
            }
        }
        f.call(_node, "")
    }
}

var makeHeap = Fn.new { FibonacciHeap.new() }

System.print("MakeHeap:")
var h = makeHeap.call()
h.visualize()

System.print("\nInsert:")
h.insert("cat")
h.visualize()

System.print("\nUnion:")
var h2 = makeHeap.call()
h2.insert("rat")
h.union(h2)
h.visualize()

System.print("\nMinimum:")
var m = h.minimum()
System.print(m)

System.print("\nExtractMin:")
// add a couple more items to demonstrate parent-child linking that
// happens on delete min.
h.insert("bat")
var x = h.insert("meerkat")  // save x for decrease key and delete demos.
m = h.extractMin()
System.print("(extracted '%(m)')")
h.visualize()

System.print("\nDecreaseKey:")
h.decreaseKey(x, "gnat")
h.visualize()

System.print("\nDelete:")
// add a couple more items.
h.insert("bobcat")
h.insert("bat")
System.print("(deleting '%(x.value)')")
h.delete(x)
h.visualize()
