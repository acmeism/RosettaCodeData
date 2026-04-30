struct Range_Bounds {
    b1 f64
	b2 f64
}

fn map_range(x Range_Bounds, y Range_Bounds, n f64) f64 {
    return y.b1 + (n - x.b1) * (y.b2 - y.b1) / (x.b2 - x.b1)
}

fn main() {
    r1 := Range_Bounds{0, 10}
    r2 := Range_Bounds{-1, 0}
    for n := 0; n <= 10; n += 2 {
        println("${n} maps to ${map_range(r1, r2, n):.2}")
    }
}
