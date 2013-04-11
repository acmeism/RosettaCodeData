func lcs(a, b string) string {
    aLen := len(a)
    bLen := len(b)
    lengths := make([][]int, aLen+1)
    for i := 0; i <= aLen; i++ {
        lengths[i] = make([]int, bLen+1)
    }
    // row 0 and column 0 are initialized to 0 already

    for i := 0; i < aLen; i++ {
        for j := 0; j < bLen; j++ {
            if a[i] == b[j] {
                lengths[i+1][j+1] = lengths[i][j]+1
            } else if lengths[i+1][j] > lengths[i][j+1] {
                lengths[i+1][j+1] = lengths[i+1][j]
            } else {
                lengths[i+1][j+1] = lengths[i][j+1]
            }
        }
    }

    // read the substring out from the matrix
    s := make([]byte, 0, lengths[aLen][bLen])
    for x, y := aLen, bLen; x != 0 && y != 0; {
        if lengths[x][y] == lengths[x-1][y] {
            x--
        } else if lengths[x][y] == lengths[x][y-1] {
            y--
        } else {
            s = append(s, a[x-1])
            x--
            y--
        }
    }
    // reverse string
    r := make([]byte, len(s))
    for i := 0; i < len(s); i++ {
        r[i] = s[len(s)-1-i]
    }
    return string(r)
}
