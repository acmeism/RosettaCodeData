fn enc(b int) int {
    return b ^ b>>1
}

fn dec(gg int) int {
    mut b := 0
    mut g := gg
    for ; g != 0; g >>= 1 {
        b ^= g
    }
    return b
}

fn main() {
    println("decimal  binary   gray    decoded")
    for b := 0; b < 32; b++ {
        g := enc(b)
        d := dec(g)
        println("  ${b:2}     ${b:05b}   ${g:05b}   ${d:05b}  ${d:2}")
    }
}
