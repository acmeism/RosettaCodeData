// version 1.1.3

typealias Func<T> = (T) -> T

fun cube(n: Int) = n * n * n

fun <T> benchmark(n: Int, func: Func<T>, arg: T): LongArray {
    val times = LongArray(n)
    for (i in 0 until n) {
         val m = System.nanoTime()
         func(arg)
         times[i] = System.nanoTime() - m
    }
    return times
}

fun main(args: Array<String>) {
    println("\nTimings (nanoseconds) : ")
    for (time in benchmark(10, ::cube, 5)) println(time)
}
