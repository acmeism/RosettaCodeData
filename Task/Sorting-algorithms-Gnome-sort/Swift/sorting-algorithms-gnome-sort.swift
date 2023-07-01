func gnomeSort<T: Comparable>(_ a: inout [T]) {
    var i = 1
    var j = 2
    while i < a.count {
        if a[i - 1] <= a[i] {
            i = j
            j += 1
        } else {
            a.swapAt(i - 1, i)
            i -= 1
            if i == 0 {
                i = j
                j += 1
            }
        }
    }
}

var array = [10, 8, 4, 3, 1, 9, 0, 2, 7, 5, 6]
print("before: \(array)")
gnomeSort(&array)
print(" after: \(array)")
