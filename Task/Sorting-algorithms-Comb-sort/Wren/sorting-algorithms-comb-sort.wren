var combSort = Fn.new { |a|
    var gap = a.count
    while (true) {
        gap = (gap/1.25).floor
        if (gap < 1) gap = 1
        var i = 0
        var swaps = false
        while (true) {
            if (a[i] > a[i+gap]) {
                var t = a[i]
                a[i] = a[i+gap]
                a[i+gap] = t
                swaps = true
            }
            i = i + 1
            if (i + gap >= a.count) break
        }
        if (gap == 1 && !swaps) return
    }
}

var array = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in array) {
    System.print("Before: %(a)")
    combSort.call(a)
    System.print("After : %(a)")
    System.print()
}
