var cocktailSort = Fn.new { |a|
    var last = a.count - 1
    while (true) {
        var swapped = false
        for (i in 0...last) {
            if (a[i] > a[i+1]) {
                var t = a[i]
                a[i] = a[i+1]
                a[i+1] = t
                swapped = true
            }
        }
        if (!swapped) return
        swapped = false
        if (last >= 1) {
            for (i in last-1..0) {
                if (a[i] > a[i+1]) {
                    var t = a[i]
                    a[i] = a[i+1]
                    a[i+1] = t
                    swapped = true
                }
            }
        }
        if (!swapped) return
    }
}

var a = [170, 45, 75, -90, -802, 24, 2, 66]
System.print("Before: %(a)")
cocktailSort.call(a)
System.print("After : %(a)")
