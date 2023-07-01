def sparseSort = { a, indices = ([] + (0..<(a.size()))) ->
    indices.sort().unique()
    a[indices] = a[indices].sort()
    a
}
