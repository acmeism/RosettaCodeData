func ackerman(m:Int, n:Int) -> Int {
    if m == 0 {
        return n+1
    } else if n == 0 {
        return ackerman(m-1, 1)
    } else {
        return ackerman(m-1, ackerman(m, n-1))
    }
}
