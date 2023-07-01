import math

fn main() {
    n := 10
    mut sum := 0.0
    for x := 1.0; x <= n; x++ {
        sum += x * x
    }
    println(math.sqrt(sum / n))
}
