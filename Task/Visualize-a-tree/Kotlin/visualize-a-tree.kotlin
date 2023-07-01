// version 1.2.0

import java.util.Random

class Stem(var str: String? = null, var next: Stem? = null)

const val SDOWN = "  |"
const val SLAST = "  `"
const val SNONE = "   "

val rand = Random()

fun tree(root: Int, head: Stem?) {
    val col = Stem()
    var head2 = head
    var tail = head
    while (tail != null) {
        print(tail.str)
        if (tail.next == null) break
        tail = tail.next
    }
    println("--$root")
    if (root <= 1) return
    if (tail != null && tail.str == SLAST) tail.str = SNONE
    if (tail == null) {
        head2 = col
        tail = head2
    }
    else {
        tail.next = col
    }
    var root2 = root
    while (root2 != 0) { // make a tree by doing something random
        val r = 1 + rand.nextInt(root2)
        root2 -= r
        col.str = if (root2 != 0) SDOWN else SLAST
        tree(r, head2)
    }
    tail.next = null
}

fun main(args: Array<String>) {
    val n = 8
    tree(n, null)
}
