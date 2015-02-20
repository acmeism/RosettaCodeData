ulong ackermann(in ulong m, in ulong n) pure nothrow @nogc {
    if (m == 0)
        return n + 1;
    if (n == 0)
        return ackermann(m - 1, 1);
    return ackermann(m - 1, ackermann(m, n - 1));
}

void main() {
    assert(ackermann(2, 4) == 11);
}
