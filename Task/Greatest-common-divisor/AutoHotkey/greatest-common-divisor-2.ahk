GCD(a, b) {
    while b
        b := Mod(a | 0x0, a := b)
    return a
}
