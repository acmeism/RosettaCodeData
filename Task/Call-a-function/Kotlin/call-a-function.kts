fun fun1() = println("No arguments")

fun fun2(i: Int) = println("One argument = $i")

fun fun3(i: Int, j: Int = 0) = println("One required argument = $i, one optional argument = $j")

fun fun4(vararg v: Int) = println("Variable number of arguments = ${v.asList()}")

fun fun5(i: Int) = i * i

fun fun6(i: Int, f: (Int) -> Int) = f(i)

fun fun7(i: Int): Double = i / 2.0

fun fun8(x: String) = { y: String -> x + " " + y }

fun main() {
    fun1()              // no arguments
    fun2(2)             // fixed number of arguments, one here
    fun3(3)             // optional argument, default value used here
    fun4(4, 5, 6)       // variable number of arguments
    fun3(j = 8, i = 7)  // using named arguments, order unimportant
    val b = false
    if (b) fun1() else fun2(9)        // statement context
    println(1 + fun6(4, ::fun5) + 3)  // first class context within an expression
    println(fun5(5))    // obtaining return value
    println(kotlin.math.round(2.5)) // no distinction between built-in and user-defined functions, though former usually have a receiver
    fun1()              // calling sub-routine which has a Unit return type by default
    println(fun7(11))   // calling function with a return type of Double (here explicit but can be implicit)
    println(fun8("Hello")("world"))   // partial application isn't supported though you can do this
}
