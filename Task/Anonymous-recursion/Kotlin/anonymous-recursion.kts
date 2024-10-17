fun fib(n: Int): Int {
   require(n >= 0)
   fun fib(k: Int, a: Int, b: Int): Int =
       if (k == 0) a else fib(k - 1, b, a + b)
   return fib(n, 0, 1)
}

fun main(args: Array<String>) {
    for (i in 0..20) print("${fib(i)} ")
    println()
}
