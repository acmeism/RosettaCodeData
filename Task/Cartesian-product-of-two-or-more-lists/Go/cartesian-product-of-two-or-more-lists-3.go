func cartN(a ...[]int) (c [][]int) {
    if len(a) == 0 {
        return [][]int{nil}
    }
    r := cartN(a[1:]...)
    for _, e := range a[0] {
        for _, p := range r {
            c = append(c, append([]int{e}, p...))
        }
    }
    return
}
