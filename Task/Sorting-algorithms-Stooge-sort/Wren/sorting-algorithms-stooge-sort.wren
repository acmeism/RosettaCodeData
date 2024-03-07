var stoogeSort // recursive
stoogeSort = Fn.new { |a, i, j|
    if (a[j] < a[i]) {
        var t = a[i]
        a[i] = a[j]
        a[j] = t
    }
    if (j - i > 1) {
        var t = ((j - i + 1)/3).floor
        stoogeSort.call(a, i, j - t)
        stoogeSort.call(a, i + t, j)
        stoogeSort.call(a, i, j - t)
    }
}

var array = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in array) {
    System.print("Before: %(a)")
    stoogeSort.call(a, 0, a.count-1)
    System.print("After : %(a)")
    System.print()
}
