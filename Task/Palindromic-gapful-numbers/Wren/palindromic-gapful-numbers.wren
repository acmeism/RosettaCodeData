import "/fmt" for Conv, Fmt

var reverse = Fn.new { |s|
    var e = 0
    while (s > 0) {
        e = e * 10 + (s % 10)
        s = (s/10).floor
    }
    return e
}

var MAX = 100000
var data = [ [1, 20, 7], [86, 100, 8], [991, 1000, 10], [9995, 10000, 12], [99996, 100000, 14] ]
var results = {}
for (d in data) {
    for (i in d[0]..d[1]) results[i] = List.filled(9, 0)
}
var p
for (d in 1..9) {
    var next_d = false
    var count = 0
    var pow = 1
    var fl = d * 11
    for (nd in 3..19) {
        var slim = (d + 1) * pow
        for (s in d*pow...slim) {
            var e = reverse.call(s)
            var mlim = (nd%2 != 1) ? 1 : 10
            for (m in 0...mlim) {
                if (nd%2 == 0) {
                    p = s*pow*10 + e
                } else {
                    p = s*pow*100 + m*pow*10 + e
                }
                if (p%fl == 0) {
                    count = count + 1
                    var rc = results[count]
                    if (rc != null) rc[d-1] = p
                    if (count == MAX) next_d = true
                }
                if (next_d) break
            }
            if (next_d) break
        }
        if (next_d) break
        if (nd%2 == 1) pow = pow * 10
    }
}

for (d in data) {
    var s1 = Fmt.ordinalize(d[0])
    var s2 = Fmt.ordinalize(d[1])
    System.print("%(s1) to %(s2) palindromic gapful numbers (> 100) ending with:")
    for (i in 1..9) {
        System.write("%(i): ")
        for (j in d[0]..d[1]) System.write("%(Fmt.d(d[2], results[j][i-1])) ")
        System.print()
    }
    System.print()
}
