fun main(args: Array<String>) {
    // build
    val dim = arrayOf(10, 15)
    val array = Array(dim[0], { IntArray(dim[1]) } )

    // fill
    array.forEachIndexed { i, it ->
        it.indices.forEach { j ->
            it[j] = 1 + i + j
        }
    }

    // print
    array.forEach { println(it.asList()) }
}
