func isEven(n:Int) -> Bool {

    // Bitwise check
    if (n & 1 != 0) {
        return false
    }

    // Mod check
    if (n % 2 != 0) {
        return false
    }
    return true
}
