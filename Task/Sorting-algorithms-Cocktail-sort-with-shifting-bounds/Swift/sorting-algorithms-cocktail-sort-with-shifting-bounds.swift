func cocktailShakerSort<T: Comparable>(_ a: inout [T]) {
    var begin = 0
    var end = a.count
    if end == 0 {
        return
    }
    end -= 1
    while begin < end {
        var new_begin = end
        var new_end = begin
        var i = begin
        while i < end {
            if a[i + 1] < a[i] {
                a.swapAt(i, i + 1)
                new_end = i
            }
            i += 1
        }
        end = new_end
        i = end
        while i > begin {
            if a[i] < a[i - 1] {
                a.swapAt(i, i - 1)
                new_begin = i
            }
            i -= 1
        }
        begin = new_begin
    }
}

var array = [5, 1, -6, 12, 3, 13, 2, 4, 0, 15]
print("before: \(array)")
cocktailShakerSort(&array)
print(" after: \(array)")

var array2 = ["one", "two", "three", "four", "five", "six", "seven", "eight"]
print("before: \(array2)")
cocktailShakerSort(&array2)
print(" after: \(array2)")
