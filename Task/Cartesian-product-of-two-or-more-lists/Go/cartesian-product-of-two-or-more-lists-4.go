func cartN(a ...[]int) (c [][]int) {
    if len(a) == 0 {
        return [][]int{nil}
    }
    last := len(a) - 1
    l := cartN(a[:last]...)
    for _, e := range a[last] {
        for _, p := range l {
            c = append(c, append(p, e))
        }
    }
    return
}
