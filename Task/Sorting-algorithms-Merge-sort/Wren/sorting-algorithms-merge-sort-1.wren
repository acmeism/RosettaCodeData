var merge = Fn.new { |left, right|
    var result = []
    while (left.count > 0 && right.count > 0) {
        if (left[0] <= right[0]) {
            result.add(left[0])
            left = left[1..-1]
        } else {
            result.add(right[0])
            right = right[1..-1]
        }
    }
    if (left.count > 0) result.addAll(left)
    if (right.count > 0) result.addAll(right)
    return result
}

var mergeSort // recursive
mergeSort = Fn.new { |m|
    var len = m.count
    if (len <= 1) return m
    var middle = (len/2).floor
    var left = m[0...middle]
    var right = m[middle..-1]
    left = mergeSort.call(left)
    right = mergeSort.call(right)
    if (left[-1] <= right[0]) {
        left.addAll(right)
        return left
    }
    return merge.call(left, right)
}

var as = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in as) {
    System.print("Before: %(a)")
    a = mergeSort.call(a)
    System.print("After : %(a)")
    System.print()
}
