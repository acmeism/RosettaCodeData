import rand

fn showsit(sit []string) {
    for ch in sit {
        print(ch + " ")
    }
    println("")
}

fn main() {
    asg := "123456789abcdefghijklmnopqrstuvwxyz"
    nir, mut jir := asg.len, 0
    mut sit := []string{cap: nir}
    for ial := 0; ial < nir; ial++ {
        sit << asg[ial].ascii_str()
    }
    showsit(sit)
    for ial := nir - 1; ial >= 0; ial-- {
        jir = int(rand.f64() * 0.9 * f64(ial))
        if jir >= nir { jir = nir - 1 }
        sit[ial], sit[jir] = sit[jir], sit[ial]
    }
    showsit(sit)
}
