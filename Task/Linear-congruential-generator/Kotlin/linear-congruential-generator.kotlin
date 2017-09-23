// version 1.1.3

class Lcg(val a: Long, val c: Long, val m: Long, val d: Long, val s: Long) {
    private var state = s

    fun nextInt(): Long {
        state = (a * state + c) % m
        return state / d
    }
}

fun main(args: Array<String>) {
    println("First 10 BSD random numbers - seed 0")
    val bsd = Lcg(1103515245, 12345, 1 shl 31, 1, 0)
    for (i in 1..10) println("${bsd.nextInt()}")
    println("\nFirst 10 MSC random numbers - seed 0")
    val msc = Lcg(214013, 2531011, 1 shl 31, 1 shl 16, 0)
    for (i in 1..10) println("${msc.nextInt()}")
}
