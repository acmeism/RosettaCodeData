func lcs(a, b string) string {
    aLen := len(a)
    bLen := len(b)
    if aLen == 0 || bLen == 0 {
        return ""
    } else if a[aLen-1] == b[bLen-1] {
        return lcs(a[:aLen-1], b[:bLen-1]) + string(a[aLen-1])
    }
    x := lcs(a, b[:bLen-1])
    y := lcs(a[:aLen-1], b)
    if len(x) > len(y) {
        return x
    }
    return y
}
