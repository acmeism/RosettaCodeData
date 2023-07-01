import rand
import math

fn main() {
    sample(100)
    sample(1000)
    sample(10000)
}

fn sample(n int) {
    // generate data
    mut d := []f64{len: n}
    for i in 0.. d.len {
        d[i] = rand.f64()
    }
    // show mean, standard deviation
    mut sum, mut ssq := f64(0), f64(0)
    for  s in d {
        sum += s
        ssq += s * s
    }
    println("$n numbers")
    m := sum / f64(n)
    println("Mean:  $m")
    println("Stddev: ${math.sqrt(ssq/f64(n)-m*m)}")
    // show histogram
    mut h := []int{len: 10}
    for s in d {
        h[int(s*10)]++
    }
    for c in h {
        println("*".repeat(c*205/int(n)))
    }
    println('')
}
