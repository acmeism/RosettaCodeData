// version 1.1.2

fun a(v: Boolean): Boolean {
    println("'a' called")
    return v
}

fun b(v: Boolean): Boolean {
    println("'b' called")
    return v
}

fun main(args: Array<String>){
    val pairs = arrayOf(Pair(true, true), Pair(true, false), Pair(false, true), Pair(false, false))
    for (pair in pairs) {
        val x = a(pair.first) && b(pair.second)
        println("${pair.first} && ${pair.second} = $x")
        val y = a(pair.first) || b(pair.second)
        println("${pair.first} || ${pair.second} = $y")
        println()
    }
}
