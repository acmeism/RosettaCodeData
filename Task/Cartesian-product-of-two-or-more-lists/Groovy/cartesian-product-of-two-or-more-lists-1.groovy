class CartesianCategory {
    static Iterable multiply(Iterable a, Iterable b) {
        assert [a,b].every { it != null }
        def (m,n) = [a.size(),b.size()]
        (0..<(m*n)).inject([]) { prod, i -> prod << [a[i.intdiv(n)], b[i%n]].flatten() }
    }
}
