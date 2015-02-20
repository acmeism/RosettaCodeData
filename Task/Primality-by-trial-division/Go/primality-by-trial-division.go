func IsPrime(num uint64) bool {
    if num < 2 { return false }
    if num == 2 { return true }
    if num%2 == 0 { return false }
    max := uint64(math.Sqrt(float64(num)))
    var i uint64
    for i = 3; i <= max; i += 2 {
        if num%i == 0 { return false }
    }
    return true
}
