// version 1.1.51

import Color.*

enum class Color { R, B }

sealed class Tree<A : Comparable<A>> {

    fun insert(x: A): Tree<A> {
        val t = ins(x)
        return when (t) {
            is T -> {
                val (_, a, y, b) = t
                T(B, a, y, b)
            }

            is E -> E()
        }
    }

    abstract fun ins(x: A): Tree<A>
}

class E<A : Comparable<A>> : Tree<A>() {

    override fun ins(x: A): Tree<A> = T(R, E(), x, E())

    override fun toString() = "E"
}

data class T<A : Comparable<A>>(
    val cl: Color,
    val le: Tree<A>,
    val aa: A,
    val ri: Tree<A>
) : Tree<A>() {

    private fun balance(): Tree<A> {
        if (cl != B) return this
        val res =
            if (le is T && le.le is T && le.cl == R && le.le.cl == R) {
               val (_, t, z, d) = this
               val (_, t2, y, c) = t as T
               val (_, a, x, b) = t2 as T
               T(R, T(B, a, x, b), y, T(B, c, z, d))
            }
            else if (le is T && le.ri is T && le.cl == R && le.ri.cl == R) {
               val (_, t, z, d) = this
               val (_, a, x, t2) = t as T
               val (_, b, y, c) = t2 as T
               T(R, T(B, a, x, b), y, T(B, c, z, d))
            }
            else if (ri is T && ri.le is T && ri.cl == R && ri.le.cl == R) {
               val (_, a, x, t) = this
               val (_, t2, z, d) = t as T
               val (_, b, y, c) = t2 as T
               T(R, T(B, a, x, b), y, T(B, c, z, d))
            }
            else if (ri is T && ri.ri is T && ri.cl == R && ri.ri.cl == R) {
               val (_, a, x, t) = this
               val (_, b, y, t2) = t as T
               val (_, c, z, d) = t2 as T
               T(R, T(B, a, x, b), y, T(B, c, z, d))
            }
            else this
        return res
    }

    override fun ins(x: A): Tree<A> = when (x.compareTo(aa)) {
        -1   -> T(cl, le.ins(x), aa, ri).balance()
        +1   -> T(cl, le, aa, ri.ins(x)).balance()
        else -> this
    }

    override fun toString() = "T($cl, $le, $aa, $ri)"
}

fun main(args: Array<String>) {
    var tree: Tree<Int> = E()
    for (i in 1..16) {
        tree = tree.insert(i)
    }
    println(tree)
}
