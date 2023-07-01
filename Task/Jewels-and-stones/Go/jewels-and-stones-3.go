func js(stones, jewels string) (n int) {
    var jSet ['z' + 1]int
    for _, b := range []byte(jewels) {
        jSet[b] = 1
    }
    for _, b := range []byte(stones) {
        n += jSet[b]
    }
    return
}
