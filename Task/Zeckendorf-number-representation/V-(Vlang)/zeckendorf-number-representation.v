fn main() {
    for i := 0; i <= 20; i++ {
        println("${i:2} ${zeckendorf(i):7b}")
    }
}

fn zeckendorf(n int) int {
    // initial arguments of fib0 = 1 and fib1 = 1 will produce
    // the Fibonacci sequence {1, 2, 3,..} on the stack as successive
    // values of fib1.
    _, set := zr(1, 1, n, 0)
    return set
}

fn zr(fib0 int, fib1 int, n int, bit u32) (int, int) {
    mut set := 0
    mut remaining := 0
    if fib1 > n {
        return n, 0
    }
    // recurse.
    // construct sequence on the way in, construct ZR on the way out.
    remaining, set = zr(fib1, fib0+fib1, n, bit+1)
    if fib1 <= remaining {
        set |= 1 << bit
        remaining -= fib1
    }
    return remaining, set
}
