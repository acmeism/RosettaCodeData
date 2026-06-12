var cycleSort = Fn.new { |a|
    var writes = 0
    var len = a.count
    for (cs in 0...len-1) {
        var item = a[cs]
        var pos = cs
        for (i in cs+1...len) {
            if (a[i] < item) pos = pos + 1
        }
        if (pos != cs) {
            while (item == a[pos]) pos = pos + 1
            var t = a[pos]
            a[pos] = item
            item = t
            while (pos != cs) {
                pos = cs
                for (i in cs+1...len) {
                    if (a[i] < item) pos = pos + 1
                }
                while (item == a[pos]) pos = pos + 1
                var t = a[pos]
                a[pos] = item
                item = t
                writes = writes + 1
            }
        }
    }
    return writes
}

var array = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in array) {
    System.print("Before : %(a)")
    var w = cycleSort.call(a)
    System.print("After  : %(a)")
    System.print("Writes : %(w)")
    System.print()
}
