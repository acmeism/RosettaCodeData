import "./fmt" for Fmt

var pancake = Fn.new { |n|
    var gap = 2
    var pg = 1
    var sumGaps = gap
    var adj = -1
    while (sumGaps < n) {
        adj = adj + 1
        var t = pg
        pg = gap
        gap = gap + t
        sumGaps = sumGaps + gap
    }
    return n + adj
}

for (i in 0..3) {
    for (j in 1..5) {
        var n = i*5 + j
        Fmt.write("p($2d) = $2d  ", n, pancake.call(n))
    }
    System.print()
}
