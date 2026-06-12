import "./sort" for Sort

var firstMissingPositive = Fn.new { |a|
    var b = a.where { |i| i > 0 }.toList
    Sort.insertion(b)
    if (b.isEmpty || b[0] > 1) return 1
    var i = 1
    while (i < b.count) {
        if (b[i] - b[i-1] > 1) return b[i-1] + 1
        i = i + 1
    }
    return b[-1] + 1
}

System.print("The first missing positive integers for the following arrays are:\n")
var aa = [
    [ 1, 2, 0], [3, 4, -1, 1], [7, 8, 9, 11, 12], [1, 2, 3, 4, 5],
    [-6, -5, -2, -1], [5, -5], [-2], [1], []
]
for (a in aa) System.print("%(a) -> %(firstMissingPositive.call(a))")
