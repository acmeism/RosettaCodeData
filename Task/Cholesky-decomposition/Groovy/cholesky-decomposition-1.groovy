def decompose = { a ->
    assert a.size > 0 && a[0].size == a.size
    def m = a.size
    def l = [].withEagerDefault { [].withEagerDefault { 0 } }
    (0..<m).each { i ->
        (0..i).each { k ->
            Number s = (0..<k).sum { j -> l[i][j] * l[k][j] } ?: 0
            l[i][k] = (i == k)
                        ? Math.sqrt(a[i][i] - s)
                        : (1.0 / l[k][k] * (a[i][k] - s))
        }
    }
    l
}
