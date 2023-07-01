fn feigenbaum() {
    max_it, max_itj := 13, 10
    mut a1, mut a2, mut d1 := 1.0, 0.0, 3.2
    println(" i       d")
    for i := 2; i <= max_it; i++ {
        mut a := a1 + (a1-a2)/d1
        for j := 1; j <= max_itj; j++ {
            mut x, mut y := 0.0, 0.0
            for k := 1; k <= 1<<u32(i); k++ {
                y = 1.0 - 2.0*y*x
                x = a - x*x
            }
            a -= x / y
        }
        d := (a1 - a2) / (a - a1)
        println("${i:2}    ${d:.8f}")
        d1, a2, a1 = d, a1, a
    }
}

fn main() {
    feigenbaum()
}
