// version 1.1.2

open class C(val x: Int)

class D(x: Int) : C(x)

fun main(args: Array<String>) {
    val c: C = D(42)        // OK because D is a sub-class of C
    println(c.x)
    val b: Byte = 100       // OK because 100 is within the range of the Byte type
    println(b)
    val s: Short = 32000    // OK because 32000 is within the range of the Short Type
    println(s)
    val l: Long = 1_000_000 // OK because any Int literal is within the range of the Long type
    println(l)
    val n : Int? = c.x      // OK because Int is a sub-class of its nullable type Int? (c.x is boxed on heap)
    println(n)
}
