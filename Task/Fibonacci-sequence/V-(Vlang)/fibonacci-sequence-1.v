fn fib_iter(n int) int {
    if n < 2 {
      return n
    }

    mut prev, mut fib := 0, 1
    for _ in 0..(n - 1){
        prev, fib = fib, prev + fib
    }
    return fib
}

fn main() {
    for val in 0..11 {
        println('fibonacci(${val:2d}) = ${fib_iter(val):3d}')
    }
}
