import rand
import math

const nmax = 20

fn main() {
    println(" N    average    analytical    (error)")
    println("===  =========  ============  =========")
    for n := 1; n <= nmax; n++ {
        a := avg(n)
        b := ana(n)
        println("${n:3}  ${a:9.4f}  ${b:12.4f}  (${math.abs(a-b)/b*100:6.2f}%)" )
    }
}

fn avg(n int) f64 {
    tests := int(1e4)
    mut sum := 0
    for _ in 0..tests {
        mut v := [nmax]bool{}
        for x := 0; !v[x];  {
            v[x] = true
            sum++
            x = rand.intn(n) or {0}
        }
    }
    return f64(sum) / tests
}

fn ana(n int) f64 {
    nn := f64(n)
    mut term := 1.0
    mut sum := 1.0
    for i := nn - 1; i >= 1; i-- {
        term *= i / nn
        sum += term
    }
    return sum
}
