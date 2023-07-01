import "./fmt" for Fmt

var canFollow = []
var arrang = []
var bFirst = true

var pmap = {}
for (i in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]) {
    pmap[i] = true
}

var ptrs
ptrs = Fn.new { |res, n, done|
    var ad = arrang[done-1]
    if (n - done <= 1) {
        if (canFollow[ad-1][n-1]) {
            if (bFirst) {
                Fmt.print("$2d", arrang)
                bFirst = false
            }
            res = res + 1
        }
    } else {
        done = done + 1
        var i = done - 1
        while (i <= n-2) {
            var ai = arrang[i]
            if (canFollow[ad-1][ai-1]) {
                arrang.swap(i, done-1)
                res = ptrs.call(res, n, done)
                arrang.swap(i, done-1)
            }
            i = i + 2
        }
    }
    return res
}

var primeTriangle = Fn.new { |n|
    canFollow = List.filled(n, null)
    for (i in 0...n) {
        canFollow[i] = List.filled(n, false)
        for (j in 0...n) canFollow[i][j] = pmap.containsKey(i+j+2)
    }
    bFirst = true
    arrang = (1..n).toList
    return ptrs.call(0, n, 1)
}

var counts = []
for (i in 2..20) {
    counts.add(primeTriangle.call(i))
}
System.print()
System.print(counts.join(" "))
