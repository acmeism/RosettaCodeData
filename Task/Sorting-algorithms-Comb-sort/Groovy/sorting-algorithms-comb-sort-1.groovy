def makeSwap = { a, i, j -> print "."; a[i] ^= a[j]; a[j] ^= a[i]; a[i] ^= a[j] }

def checkSwap = { a, i, j -> [(a[i] > a[j])].find { it }.each { makeSwap(a, i, j) } }

def combSort = { input ->
    def swap = checkSwap.curry(input)
    def size = input.size()
    def gap = size
    def swapped = true
    while (gap != 1 || swapped) {
        gap = (gap / 1.247330950103979) as int
        gap = (gap < 1) ? 1 : gap
        swapped = (0..<(size-gap)).any { swap(it, it + gap) }
    }
    input
}
