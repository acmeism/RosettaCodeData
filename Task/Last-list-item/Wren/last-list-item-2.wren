var findMin = Fn.new { |a|
    var ix = 0
    var min = a[0]
    for (i in 1...a.count) {
        if (a[i] < min) {
            ix = i
            min = a[i]
        }
    }
    return [min, ix]
}

var a = [6, 81, 243, 14, 25, 49, 123, 69, 11]

while (a.count > 1) {
    System.print("List: %(a)")
    var s = List.filled(2, 0)
    for (i in 0..1) {
        var m = findMin.call(a)
        s[i] = m[0]
        a.removeAt(m[1])
    }
    var sum = s[0] + s[1]
    System.print("Two smallest: %(s[0]) + %(s[1]) = %(sum)")
    a.add(sum)
}

System.print("Last item is %(a[0]).")
