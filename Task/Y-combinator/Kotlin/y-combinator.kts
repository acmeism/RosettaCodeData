// version 1.1.2

typealias Func<T, R> = (T) -> R

class RecursiveFunc<T, R>(val p: (RecursiveFunc<T, R>) -> Func<T, R>)

fun <T, R> y(f: (Func<T, R>) -> Func<T, R>): Func<T, R> {
    val rec = RecursiveFunc<T, R> { r -> f { r.p(r)(it) } }
    return rec.p(rec)
}

fun fac(f: Func<Int, Int>) = { x: Int -> if (x <= 1) 1 else x * f(x - 1) }

fun fib(f: Func<Int, Int>) = { x: Int -> if (x <= 2) 1 else f(x - 1) + f(x - 2) }

fun main(args: Array<String>) {
    print("Factorial(1..10)   : ")
    for (i in 1..10) print("${y(::fac)(i)}  ")
    print("\nFibonacci(1..10)   : ")
    for (i in 1..10) print("${y(::fib)(i)}  ")
    println()
}
