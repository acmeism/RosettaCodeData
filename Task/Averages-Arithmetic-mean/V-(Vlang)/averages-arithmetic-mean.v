import math
import arrays

fn main() {
    for v in [
        []f64{},                         // mean returns ok = false
        [math.inf(1), math.inf(1)], // answer is +Inf

        // answer is NaN, and mean returns ok = true, indicating NaN
        // is the correct result
        [math.inf(1), math.inf(-1)],

        [f64(3), 1, 4, 1, 5, 9],

        [f64(10), 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 0, 0, .11],
        [f64(10), 20, 30, 40, 50, -100, 4.7, -11e2],
    ] {
        println("Vector: $v")
        m := arrays.fold(v, 0.0, fn(r f64, v f64) f64 { return r+v })/v.len
        println("Mean of $v.len numbers is $m\n")
    }
}
