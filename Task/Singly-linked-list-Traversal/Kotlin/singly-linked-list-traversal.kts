fun main(args: Array<String>) {
    val list = IntRange(1, 50).toList()

    // classic traversal:
    for (i in list) { print("%4d ".format(i)); if (i % 10 == 0) println() }

    // list iterator:
    list.asReversed().forEach { print("%4d ".format(it)); if (it % 10 == 1) println() }
}
