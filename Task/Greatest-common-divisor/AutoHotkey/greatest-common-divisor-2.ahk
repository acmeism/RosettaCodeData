gcd(a, b) {
    while b
        t := b, b := Mod(a, b), a := t
    return, a
}
