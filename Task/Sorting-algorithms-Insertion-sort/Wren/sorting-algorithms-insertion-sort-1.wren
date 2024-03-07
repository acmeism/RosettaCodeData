var insertionSort = Fn.new { |a|
    for (i in 1..a.count-1) {
        var v = a[i]
        var j = i - 1
        while (j >= 0 && a[j] > v) {
            a[j+1] = a[j]
            j = j - 1
        }
        a[j+1] = v
    }
}

var array = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in array) {
    System.print("Before: %(a)")
    insertionSort.call(a)
    System.print("After : %(a)")
    System.print()
}
