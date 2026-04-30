fn lagarias(nir int) int {
    if nir < 0 { return -lagarias(-nir) }
    if nir == 0 || nir == 1 { return 0 }
    mut fir := 2
    for fir <= nir && nir % fir != 0 {
        fir += 1
    }
    qir := nir / fir
    if qir == 1 { return 1 }
    return qir * lagarias(fir) + fir * lagarias(qir)
}

fn main() {
    for nal in -99 .. 101 {
        print("${lagarias(nal)} ")
    }
    println("")
}
