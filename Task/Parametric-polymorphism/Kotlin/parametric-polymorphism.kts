// version 1.0.6

class BinaryTree<T>(var value: T) {
    var left : BinaryTree<T>? = null
    var right: BinaryTree<T>? = null

    fun <U> map(f: (T) -> U): BinaryTree<U> {
        val tree = BinaryTree<U>(f(value))
        if (left  != null) tree.left  = left?.map(f)
        if (right != null) tree.right = right?.map(f)
        return tree
    }

    fun showTopThree() = "(${left?.value}, $value, ${right?.value})"
}

fun main(args: Array<String>) {
    val b   = BinaryTree(6)
    b.left  = BinaryTree(5)
    b.right = BinaryTree(7)
    println(b.showTopThree())
    val b2  = b.map { it * 10.0 }
    println(b2.showTopThree())
}
