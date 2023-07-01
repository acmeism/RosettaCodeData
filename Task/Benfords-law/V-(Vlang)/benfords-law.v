import math

fn fib1000() []f64 {
    mut a, mut b, mut r := 0.0, 1.0, []f64{len:1000}
    for i in 0..r.len {
        r[i], a, b = b, b, b+a
    }
    return r
}

fn main() {
    show(fib1000(), "First 1000 Fibonacci numbers")
}

fn show(c []f64, title string) {
    mut f := [9]int{}
    for v in c {
        f["$v"[0]-'1'[0]]++
    }
    println(title)
    println("Digit  Observed  Predicted")
    for i, n in f {
        println("  ${i+1}  ${f64(n)/f64(c.len):9.3f}  ${math.log10(1+1/f64(i+1)):8.3f}")
    }
}
