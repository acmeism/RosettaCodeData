func nxm(n, m int) [][]int {
    d2 := make([][]int, n)
    for i := range d2 {
        d2[i] = make([]int, m)
    }
    return d2
}
