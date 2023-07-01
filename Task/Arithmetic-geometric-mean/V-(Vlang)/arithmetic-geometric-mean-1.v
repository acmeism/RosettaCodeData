import math

const ep = 1e-14

fn agm(aa f64, gg f64) f64 {
    mut a, mut g := aa, gg
    for math.abs(a-g) > math.abs(a)*ep {
        t := a
        a, g = (a+g)*.5, math.sqrt(t*g)
    }
    return a
}

fn main() {
    println(agm(1.0, 1.0/math.sqrt2))
}
