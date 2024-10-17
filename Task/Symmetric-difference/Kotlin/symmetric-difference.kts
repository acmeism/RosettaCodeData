// version 1.1.2

fun main(args: Array<String>) {
    val a = setOf("John", "Bob", "Mary", "Serena")
    val b = setOf("Jim", "Mary", "John", "Bob")
    println("A     = $a")
    println("B     = $b")
    val c =  a - b
    println("A \\ B = $c")
    val d = b - a
    println("B \\ A = $d")
    val e = c.union(d)
    println("A Δ B = $e")
}
