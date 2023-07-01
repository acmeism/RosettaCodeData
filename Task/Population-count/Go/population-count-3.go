func pop64(w uint64) (c int) {
    for w != 0 {
        w &= w - 1
        c++
    }
    return
}
