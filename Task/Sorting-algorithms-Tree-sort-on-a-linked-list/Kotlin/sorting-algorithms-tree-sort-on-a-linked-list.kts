// version 1.1.51

import java.util.LinkedList

class BinaryTree<T : Comparable<T>> {
    var node: T? = null
    lateinit var leftSubTree: BinaryTree<T>
    lateinit var rightSubTree: BinaryTree<T>

    fun insert(item: T) {
        if (node == null) {
            node = item
            leftSubTree = BinaryTree<T>()
            rightSubTree = BinaryTree<T>()
        }
        else if (item < node as T) {
            leftSubTree.insert(item)
        }
        else {
            rightSubTree.insert(item)
        }
    }

    fun inOrder() {
        if (node == null) return
        leftSubTree.inOrder()
        print("$node ")
        rightSubTree.inOrder()
    }
}

fun <T : Comparable<T>> LinkedList<T>.treeSort() {
    val searchTree = BinaryTree<T>()
    for (item in this) searchTree.insert(item)
    print("${this.joinToString(" ")} -> ")
    searchTree.inOrder()
    println()
}

fun main(args: Array<String>) {
    val ll = LinkedList(listOf(5, 3, 7, 9, 1))
    ll.treeSort()
    val ll2 = LinkedList(listOf('d', 'c', 'e', 'b' , 'a'))
    ll2.treeSort()
}
