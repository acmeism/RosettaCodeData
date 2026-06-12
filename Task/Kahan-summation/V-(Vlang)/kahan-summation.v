fn kahan(s ...f64) f64 {
    mut tot, mut c := 0.0, 0.0
    for x in s {
        y := x - c
        t := tot + y
        c = (t - tot) - y
        tot = t
    }
    return tot
}

fn epsilon() f64 {
    mut e := 1.0
    for 1+e != 1 {
        e /= 2
    }
    return e
}

fn main() {
    a := 1.0
    b := epsilon()
    c := -b
    println("Left associative: ${a+b+c}")
    println("Kahan summation:  ${kahan(a, b, c)}")
    println("Epsilon:          $b")
}
