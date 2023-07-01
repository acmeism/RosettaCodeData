func js(stones, jewels string) (n int) {
    for _, b := range []byte(jewels) {
        n += strings.Count(stones, string(b))
    }
    return
}
