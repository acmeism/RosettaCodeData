var rgs = [
    [2, 1000, true],
    [1000, 4000, true],
    [2, 1e4, false],
    [2, 1e5, false],
    [2, 1e6, false],
    [2, 1e7, false],
    [2, 1e8, false],
    [2, 1e9, false]
]
for (rg in rgs) {
    if (rg[0] == 2) {
        System.print("eban numbers up to and including %(rg[1])")
    } else {
        System.print("eban numbers between %(rg[0]) and %(rg[1]) (inclusive):")
    }
    var count = 0
    var i = rg[0]
    while (i <= rg[1]) {
        var b = (i/1e9).floor
        var r = i % 1e9
        var m = (r/1e6).floor
        r = i % 1e6
        var t = (r/1000).floor
        r = r % 1000
        if (m >= 30 && m <= 66) m = m % 10
        if (t >= 30 && t <= 66) t = t % 10
        if (r >= 30 && r <= 66) r = r % 10
        if (b == 0 || b == 2 || b == 4 || b == 6) {
            if (m == 0 || m == 2 || m == 4 || m == 6) {
                if (t == 0 || t == 2 || t == 4 || t == 6) {
                    if (r == 0 || r == 2 || r == 4 || r == 6) {
                        if (rg[2]) System.write("%(i) ")
                        count = count + 1
                    }
                }
            }
        }
        i = i + 2
    }
    if (rg[2]) System.print()
    System.print("count = %(count)\n")
}
