func js(stones, jewels string) (n int) {
    var sset ['z' + 1]int
    for _, b := range []byte(stones) {
        sset[b]++
    }
    for _, b := range []byte(jewels) {
        n += sset[b]
    }
    return
}
