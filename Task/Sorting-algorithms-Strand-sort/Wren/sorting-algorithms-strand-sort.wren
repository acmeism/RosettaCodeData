var merge = Fn.new { |left, right|
    var res = []
    while (!left.isEmpty && !right.isEmpty) {
        if (left[0] <= right[0]) {
            res.add(left[0])
            left.removeAt(0)
        } else {
            res.add(right[0])
            right.removeAt(0)
        }
    }
    res.addAll(left)
    res.addAll(right)
    return res
}

var strandSort = Fn.new { |a|
    var list = a.toList
    var res = []
    while (!list.isEmpty) {
        var sorted = [list[0]]
        list.removeAt(0)
        var leftover = []
        for (item in list) {
            if (sorted[-1] <= item) {
                sorted.add(item)
            } else {
                leftover.add(item)
            }
        }
        res = merge.call(sorted, res)
        list = leftover
    }
    return res
}

var a = [-2, 0, -2, 5, 5, 3, -1, -3, 5, 5, 0, 2, -4, 4, 2]
System.print("Unsorted: %(a)")
a = strandSort.call(a)
System.print("Sorted  : %(a)")
