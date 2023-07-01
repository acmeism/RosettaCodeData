def accumulator = { Number n ->
    def value = n;
    { it = 0 -> value += it}
}
