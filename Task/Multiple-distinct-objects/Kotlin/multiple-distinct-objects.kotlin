// version 1.1.2

class Foo {
    val id: Int

    init {
       id = ++numCreated // creates a distict id for each object
    }

    companion object {
        private var numCreated = 0
    }
}

fun main(args: Array<String>) {
    val n = 3  // say

    /* correct approach - creates references to distinct objects */
    val fooList = List(n) { Foo() }
    for (foo in fooList) println(foo.id)

    /* incorrect approach - creates references to same object */
    val f = Foo()
    val fooList2 = List(n) { f }
    for (foo in fooList2) println(foo.id)
}
