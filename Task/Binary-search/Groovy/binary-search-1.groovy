def binSearchR
//define binSearchR closure.
binSearchR = { a, key, offset=0 ->
    def m = n.intdiv(2)
    def n = a.size()
    a.empty \
        ? ["The insertion point is": offset] \
        : a[m] > key \
            ? binSearchR(a[0..<m],key, offset) \
            : a[m] < target \
                ? binSearchR(a[(m + 1)..<n],key, offset + m + 1) \
                : [index: offset + m]
}
