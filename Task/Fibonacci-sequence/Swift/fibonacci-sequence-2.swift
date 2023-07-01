func fibonacci(n: Int) -> Int {
    if n < 2 {
        return n
    }
    var fibPrev = 1
    var fib = 1
    for num in 2...n {
        (fibPrev, fib) = (fib, fib + fibPrev)
    }
    return fib
}
