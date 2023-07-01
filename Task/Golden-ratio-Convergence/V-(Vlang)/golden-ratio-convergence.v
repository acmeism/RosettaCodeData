import math

fn main() {
    limit := 1e-5
	mut old_phi := 1.0
	mut iters := 0
    mut phi, mut actual_phi := f64(0), f64(0)
    for {
        phi = 1 + 1 / old_phi
        iters++
        if math.abs(phi - old_phi) <= limit {break}
        old_phi = phi
    }
    println("Final value of phi : ${phi:.14f}")
    actual_phi = (1.0 + math.sqrt(5.0)) / 2.0
    println("Number of iterations : ${iters}")
    println("Error (approx) : ${phi - actual_phi:.14f}")
}
