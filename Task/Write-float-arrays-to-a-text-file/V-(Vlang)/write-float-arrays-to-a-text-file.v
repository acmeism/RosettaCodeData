import strconv
import os

const x = [f64(1.0), 2, 3, 1e11]
const y = [f64(1.0), 1.4142135623730951, 1.7320508075688772, 316227.76601683791]
const xp = 3
const yp = 5

fn main() {
    if x.len != y.len {
        println("x, y different length")
        return
    }
	mut file := os.create("filename.txt")!
	defer { file.close() }
    for idx, _ in x {
        fsg := unsafe {strconv.v_sprintf("%.${xp - 1}e, %.${yp - 1}e", x[idx], y[idx])}
        file.write_string("${fsg}\n")!
    }
}
