class Node {
    construct new(key, parent) {
        _key = key
        _parent = parent
        _balance = 0
        _left = null
        _right = null
    }

    key     { _key     }
    parent  { _parent  }
    balance { _balance }
    left    { _left    }
    right   { _right   }

    key=(k)     { _key = k     }
    parent=(p)  { _parent = p  }
    balance=(v) { _balance = v }
    left=(n)    { _left = n    }
    right= (n)  { _right = n   }
}

class AvlTree {
    construct new() {
        _root = null
    }

    insert(key) {
        if (!_root) {
            _root = Node.new(key, null)
        } else {
            var n = _root
            while (true) {
                if (n.key == key) return false
                var parent = n
                var goLeft = n.key > key
                n = goLeft ? n.left : n.right
                if (!n) {
                    if (goLeft) {
                        parent.left  = Node.new(key, parent)
                    } else {
                        parent.right = Node.new(key, parent)
                    }
                    rebalance(parent)
                    break
                }
            }
       }
       return true
    }

    delete(delKey) {
        if (!_root) return
        var n       = _root
        var parent  = _root
        var delNode = null
        var child   = _root
        while (child) {
            parent = n
            n = child
            child = (delKey >= n.key) ? n.right : n.left
            if (delKey == n.key) delNode = n
        }
        if (delNode) {
            delNode.key = n.key
            child = n.left ? n.left : n.right
            if (_root.key == delKey) {
                _root = child
                if (_root) _root.parent = null
            } else {
                if (parent.left == n) {
                    parent.left = child
                } else {
                    parent.right = child
                }
                if (child) child.parent = parent
                rebalance(parent)
            }
        }
    }

    rebalance(n) {
        setBalance([n])
        var nn = n
        if (nn.balance == -2) {
            if (height(nn.left.left) >= height(nn.left.right)) {
                nn = rotateRight(nn)
            } else {
                nn = rotateLeftThenRight(nn)
            }
        } else if (nn.balance == 2) {
            if (height(nn.right.right) >= height(nn.right.left)) {
                nn = rotateLeft(nn)
            } else {
                nn = rotateRightThenLeft(nn)
            }
        }
        if (nn.parent) rebalance(nn.parent) else _root = nn
    }

    rotateLeft(a) {
        var b = a.right
        b.parent = a.parent
        a.right = b.left
        if (a.right) a.right.parent = a
        b.left = a
        a.parent = b
        if (b.parent) {
            if (b.parent.right == a) {
                b.parent.right = b
            } else {
                b.parent.left = b
            }
        }
        setBalance([a, b])
        return b
    }

    rotateRight(a) {
        var b = a.left
        b.parent = a.parent
        a.left = b.right
        if (a.left) a.left.parent = a
        b.right = a
        a.parent = b
        if (b.parent) {
            if (b.parent.right == a) {
                b.parent.right = b
            } else {
                b.parent.left = b
            }
        }
        setBalance([a, b])
        return b
    }

    rotateLeftThenRight(n) {
        n.left = rotateLeft(n.left)
        return rotateRight(n)
    }

    rotateRightThenLeft(n) {
        n.right = rotateRight(n.right)
        return rotateLeft(n)
    }

    height(n) {
        if (!n) return -1
        return 1 + height(n.left).max(height(n.right))
    }

    setBalance(nodes) {
        for (n in nodes) n.balance = height(n.right) - height(n.left)
    }

    printKey() {
        printKey(_root)
        System.print()
    }

    printKey(n) {
        if (n) {
            printKey(n.left)
            System.write("%(n.key) ")
            printKey(n.right)
        }
    }

    printBalance() {
        printBalance(_root)
        System.print()
    }

    printBalance(n) {
        if (n) {
            printBalance(n.left)
            System.write("%(n.balance) ")
            printBalance(n.right)
        }
    }
}

var tree = AvlTree.new()
System.print("Inserting values 1 to 10")
for (i in 1..10) tree.insert(i)
System.write("Printing key     : ")
tree.printKey()
System.write("Printing balance : ")
tree.printBalance()
