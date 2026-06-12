BEGIN {
    o = 1
    src[o++] = 13
    do {
        r = src[++i]
        n = src[++i]
        for (p = 2; p != 9; p += p % 2 + 1) {
            if (p >= r) {
                if (p == r) res = res " " n p
                break
            }
            src[++o] = r - p
            src[++o] = n p
        }
    } while (i != o)
    print substr(res, 2)
}
