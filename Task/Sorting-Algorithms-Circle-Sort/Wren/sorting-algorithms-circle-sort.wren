var circleSort // recursive
circleSort = Fn.new { |a, lo, hi, swaps|
    if (lo == hi) return swaps
    var high = hi
    var low = lo
    var mid = ((hi-lo)/2).floor
    while (lo < hi) {
        if (a[lo] > a[hi]) {
            var t = a[lo]
            a[lo] = a[hi]
            a[hi] = t
            swaps = swaps + 1
        }
        lo = lo + 1
        hi = hi - 1
    }
    if (lo == hi) {
        if (a[lo] > a[hi+1]) {
            var t = a[lo]
            a[lo] = a[hi+1]
            a[hi+1] = t
            swaps = swaps + 1
        }
    }
    swaps = circleSort.call(a, low, low + mid, swaps)
    swaps = circleSort.call(a, low + mid + 1, high, swaps)
    return swaps
}

var as = [ [6, 7, 8, 9, 2, 5, 3, 4, 1], [2, 14, 4, 6, 8, 1, 3, 5, 7, 11, 0, 13, 12, -1] ]
for (a in as) {
    System.print("Before: %(a)")
    while (circleSort.call(a, 0, a.count-1, 0) != 0) {}
    System.print("After : %(a)")
    System.print()
}
