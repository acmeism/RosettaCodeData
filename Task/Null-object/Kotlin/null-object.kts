// version 1.1.0

fun main(args: Array<String>) {
    val i: Int  = 3           // non-nullable Int type - can't be assigned null
    println(i)
    val j: Int? = null        // nullable Int type - can be assigned null
    println(j)
    println(null is Nothing?) // test that null is indeed of type Nothing?
}
