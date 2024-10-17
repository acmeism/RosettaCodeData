// version 1.0.6

fun main(args: Array<String>) {
    val s = "0123456789"
    val n = 3
    val m = 4
    val c = '5'
    val z = "12"
    var i: Int
    println(s.substring(n, n + m))
    println(s.substring(n))
    println(s.dropLast(1))
    i = s.indexOf(c)
    println(s.substring(i, i + m))
    i = s.indexOf(z)
    println(s.substring(i, i + m))
}
