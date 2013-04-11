def binSearchR
binSearchR = { a, target, offset=0 ->
    def n = a.size()
    def m = n.intdiv(2)
    a.empty \
        ? ["insertion point": offset] \
        : a[m] > target \
            ? binSearchR(a[0..<m], target, offset) \
            : a[m] < target \
                ? binSearchR(a[(m + 1)..<n], target, offset + m + 1) \
                : [index: offset + m]
}
