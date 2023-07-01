var orderLists = Fn.new { |l1, l2|
    var len = (l1.count <= l2.count) ? l1.count : l2.count
    for (i in 0...len) {
        if (l1[i] < l2[i]) return true
        if (l1[i] > l2[i]) return false
    }
    return (l1.count < l2.count)
}

var lists = [
    [1, 2, 3, 4, 5],
    [1, 2, 1, 5, 2, 2],
    [1, 2, 1, 5, 2],
    [1, 2, 1, 5, 2],
    [1, 2, 1, 3, 2],
    [1, 2, 0, 4, 4, 0, 0, 0],
    [1, 2, 0, 4, 4, 1, 0, 0],
    [1, 2, 0, 4, 4, 1, 0, 1]
]

for (i in 0...lists.count) System.print("list[%(i)] : %(lists[i])")
System.print()
for (i in 0...lists.count-1) {
    var res = orderLists.call(lists[i], lists[i+1])
    System.print("list[%(i)] < list[%(i+1)] -> %(res)")
}
