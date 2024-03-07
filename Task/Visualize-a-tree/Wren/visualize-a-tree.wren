import "./dynamic" for Struct
import "random" for Random

var Stem = Struct.create("Stem", ["str", "next"])

var SDOWN = "  |"
var SLAST = "  `"
var SNONE = "   "

var rand = Random.new()

var tree // recursive
tree = Fn.new { |root, head|
    var col = Stem.new(null, null)
    var tail = head
    while (tail) {
        System.write(tail.str)
        if (!tail.next) break
        tail = tail.next
    }
    System.print("--%(root)")
    if (root <= 1) return
    if (tail && tail.str == SLAST) tail.str = SNONE
    if (!tail) {
        tail = head = col
    } else {
        tail.next = col
    }
    while (root != 0) { // make a tree by doing something random
        var r = 1 + rand.int(root)
        root = root - r
        col.str = (root != 0) ? SDOWN : SLAST
        tree.call(r, head)
    }
    tail.next = null
}

var n = 8
tree.call(n, null)
