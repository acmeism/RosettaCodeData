BEGIN {
    m = 2
    for (n = 0; n != 8; ++n) {
        m = m * 10 - 17
        printf "%u %9u^2 %'20u\n", n, m, m * m
    }
}
