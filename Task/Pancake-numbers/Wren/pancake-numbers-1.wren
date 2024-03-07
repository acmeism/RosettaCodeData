import "./fmt" for Fmt

var pancake = Fn.new { |n|
    var gap = 2
    var sum = 2
    var adj = -1
    while (sum < n) {
        adj = adj + 1
        gap = gap*2 - 1
        sum = sum + gap
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
