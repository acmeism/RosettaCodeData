var shellSort = Fn.new { |a|
    var n = a.count
    var gaps = [701, 301, 132, 57, 23, 10, 4, 1]
    for (gap in gaps) {
        if (gap < n) {
            for (i in gap...n) {
                var t = a[i]
                var j = i
                while (j >= gap && a[j-gap] > t) {
                    a[j] = a[j - gap]
                    j = j - gap
                }
                a[j] = t
            }
        }
    }
}

var array = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in array) {
    System.print("Before: %(a)")
    shellSort.call(a)
    System.print("After : %(a)")
    System.print()
}
