def ack ( m, n ) {
    assert m >= 0 && n >= 0 : 'both arguments must be non-negative'
    m == 0 ? n + 1 : n == 0 ? ack(m-1, 1) : ack(m-1, ack(m, n-1))
}
