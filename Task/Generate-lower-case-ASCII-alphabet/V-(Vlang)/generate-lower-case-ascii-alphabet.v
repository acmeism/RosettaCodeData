fn loweralpha() string {
    mut p := []u8{len: 26}
    for i in 97..123 {
        p[i-97] = u8(i)
    }
    return p.bytestr()
}
