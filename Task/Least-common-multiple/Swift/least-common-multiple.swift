func lcm(a:Int, b:Int) -> Int {
    return abs(a * b) / gcd_rec(a, b)
}
