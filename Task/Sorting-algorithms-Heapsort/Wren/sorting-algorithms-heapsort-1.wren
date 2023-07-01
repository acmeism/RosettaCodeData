var siftDown = Fn.new { |a, start, end|
    var root = start
    while (root*2 + 1 <= end) {
        var child = root*2 + 1
        if (child + 1 <= end && a[child] < a[child+1]) child = child + 1
        if (a[root] < a[child]) {
            var t = a[root]
            a[root] = a[child]
            a[child] = t
            root = child
        } else {
            return
        }
    }
}

var heapify = Fn.new { |a, count|
    var start = ((count - 2)/2).floor
    while (start >= 0) {
        siftDown.call(a, start, count - 1)
        start = start - 1
    }
}

var heapSort = Fn.new { |a|
    var count = a.count
    heapify.call(a, count)
    var end = count - 1
    while (end > 0) {
        var t = a[end]
        a[end] = a[0]
        a[0] = t
        end = end - 1
        siftDown.call(a, 0, end)
    }
}

var as = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in as) {
    System.print("Before: %(a)")
    heapSort.call(a)
    System.print("After : %(a)")
    System.print()
}
