fn fib_rec(n int) int {
    if n < 2 {
      return n
    }
    return fib_rec(n - 2) + fib_rec(n - 1)
}

fn main() {
    for val in 0..11 {
        println('fibonacci(${val:2d}) = ${fib_rec(val):3d}')
    }
}
