var gnomeSort = Fn.new { |a, asc|
    var size = a.count
    var i = 1
    var j = 2
    while (i < size) {
        if ((asc && a[i-1] <= a[i]) || (!asc && a[i-1] >= a[i])) {
            i = j
            j = j + 1
        } else {
            var t = a[i-1]
            a[i-1] = a[i]
            a[i] = t
            i = i - 1
            if (i == 0) {
                i = j
                j = j + 1
            }
        }
    }
}

var as = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]

for (asc in [true, false]) {
    System.print("Sorting in %(asc ? "ascending" : "descending") order:\n")
    for (a in as) {
        var b = (asc) ? a : a.toList
        System.print("Before: %(b)")
        gnomeSort.call(b, asc)
        System.print("After : %(b)")
        System.print()
    }
}
