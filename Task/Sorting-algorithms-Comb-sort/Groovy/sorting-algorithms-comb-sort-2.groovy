def combSort11 = { input ->
    def swap = checkSwap.curry(input)
    def size = input.size()
    def gap = size
    def swapped = true
    while (gap != 1 || swapped) {
        gap = (gap / 1.247330950103979) as int
        gap = ((gap < 1) ? 1 : ([10,9].contains(gap) ? 11 : gap))
        swapped = (0..<(size-gap)).any { swap(it, it + gap) }
    }
    input
}
