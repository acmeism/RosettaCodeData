func circleSort<T: Comparable>(_ array: inout [T]) {
    func circSort(low: Int, high: Int, swaps: Int) -> Int {
        if low == high {
            return swaps
        }
        var lo = low
        var hi = high
        let mid = (hi - lo) / 2
        var s = swaps
        while lo < hi {
            if array[lo] > array[hi] {
                array.swapAt(lo, hi)
                s += 1
            }
            lo += 1
            hi -= 1
        }
        if lo == hi {
            if array[lo] > array[hi + 1] {
                array.swapAt(lo, hi + 1)
                s += 1
            }
        }
        s = circSort(low: low, high: low + mid, swaps: s)
        s = circSort(low: low + mid + 1, high: high, swaps: s)
        return s
    }
    while circSort(low: 0, high: array.count - 1, swaps: 0) != 0 {}
}

var array = [10, 8, 4, 3, 1, 9, 0, 2, 7, 5, 6]
print("before: \(array)")
circleSort(&array)
print(" after: \(array)")

var array2 = ["one", "two", "three", "four", "five", "six", "seven", "eight"]
print("before: \(array2)")
circleSort(&array2)
print(" after: \(array2)")
