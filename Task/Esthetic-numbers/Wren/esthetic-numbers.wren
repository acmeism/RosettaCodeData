import "./fmt" for Conv, Fmt

var isEsthetic = Fn.new { |n, b|
    if (n == 0) return false
    var i = n % b
    n = (n/b).floor
    while (n > 0) {
        var j = n % b
        if ((i - j).abs != 1) return false
        n = (n/b).floor
        i = j
    }
    return true
}

var esths = []

var dfs  // recursive function
dfs = Fn.new { |n, m, i|
    if (i >= n && i <= m) esths.add(i)
    if (i == 0 || i > m) return
    var d = i % 10
    var i1 = i*10 + d - 1
    var i2 = i1 + 2
    if (d == 0) {
        dfs.call(n, m, i2)
    } else if (d == 9) {
        dfs.call(n, m, i1)
    } else {
        dfs.call(n, m, i1)
        dfs.call(n, m, i2)
    }
}

var listEsths = Fn.new { |n, n2, m, m2, perLine, all|
    esths.clear()
    for (i in 0..9) dfs.call(n2, m2, i)
    var le = esths.count
    Fmt.print("Base 10: $,d esthetic numbers between $,d and $,d", le, n, m)
    if (all) {
        var c = 0
        for (esth in esths) {
            System.write("%(esth) ")
            if ((c+1)%perLine == 0) System.print()
            c = c + 1
        }
    } else {
        for (i in 0...perLine) System.write("%(Conv.dec(esths[i])) ")
        System.print("\n............\n")
        for (i in le-perLine...le) System.write("%(Conv.dec(esths[i])) ")
    }
    System.print("\n")
}

for (b in 2..16) {
    System.print("Base %(b): %(4*b)th to %(6*b)th esthetic numbers:")
    var n = 1
    var c = 0
    while (c < 6*b) {
        if (isEsthetic.call(n, b)) {
            c = c + 1
            if (c >= 4*b) System.write("%(Conv.itoa(n, b)) ")
        }
        n = n + 1
    }
    System.print("\n")
}

// the following all use the obvious range limitations for the numbers in question
listEsths.call(1000, 1010, 9999, 9898, 16, true)
listEsths.call(1e8, 101010101, 13*1e7, 123456789, 9, true)
listEsths.call(1e11, 101010101010, 13*1e10, 123456789898, 7, false)
listEsths.call(1e14, 101010101010101, 13*1e13, 123456789898989, 5, false)
