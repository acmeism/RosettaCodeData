// version 1.1

fun foo(n: Double): (d: Double) -> Double {
    var nn = n
    return { nn += it; nn }
}

fun foo(n: Int): (i: Int) -> Int {
    var nn = n
    return { nn += it; nn }
}

fun main(args: Array<String>) {
    val x = foo(1.0) // calls 'Double' overload
    x(5.0)
    foo(3.0)
    println(x(2.3))
    val y = foo(1)   // calls 'Int' overload
    y(5)
    foo(5)
    println(y(2))
}
