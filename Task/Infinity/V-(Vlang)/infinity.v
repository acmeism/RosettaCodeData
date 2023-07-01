import math

fn main() {
    mut x := 1.5 // type of x determined by literal
    // that this compiles demonstrates that PosInf returns same type as x,
    // the type specified by the task.
    x = math.inf(1)
    println('$x ${math.is_inf(x, 1)}') // demonstrate result
}
