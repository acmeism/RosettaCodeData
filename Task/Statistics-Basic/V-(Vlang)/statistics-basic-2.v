import rand
import math.stats

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
    println("$n numbers")
    m := stats.mean<f64>(d)//sum / f64(n)
    println("Mean:  $m")
    println("Stddev: ${stats.sample_stddev<f64>(d)}")
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
