import math
const epsilon = 1.0e-15

fn main() {
    mut fact := u64(1)
    mut e := 2.0
    mut n := u64(2)
    for {
        e0 := e
        fact *= n
        n++
        e += 1.0 / f64(fact)
        if math.abs(e - e0) < epsilon {
            break
        }
    }
    println("e = ${e:.15f}")
}
