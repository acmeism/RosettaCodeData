BEGIN {
    for (m2 = m3 = o = 1; o <= 1000000; ++o) {
        klarner_rado[o] = m = m2 < m3 ? m2 : m3
        if (m2 == m) m2 = klarner_rado[++i2] * 2 + 1
        if (m3 == m) m3 = klarner_rado[++i3] * 3 + 1
    }

    for (i = 1; i < 100; ++i)
        printf "%u ", klarner_rado[i]
    for (i = 100; i < o; i *= 10)
        print klarner_rado[i]
}
