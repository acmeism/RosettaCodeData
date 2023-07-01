func nxm(n, m int) [][]int {
    d1 := make([]int, m)
    d2 := make([][]int, n)
    for i := range d2 {
        d2[i] = d1
    }
    return d2
}
