import "./fmt" for Fmt

var lowSquareStartN = Fn.new { |n|
    var sqrtN = n.sqrt
    var sqrtN10 = (n * 10).sqrt
    var pow10 = 1
    while (true) {
        for (i in [sqrtN.truncate, sqrtN10.truncate]) {
            for (j in 0..1) {
                var mySqr = (i * i / pow10).floor
                if (mySqr == n) return i
                i = i + 1
            }
            pow10 = pow10 * 10
        }
        sqrtN = sqrtN * 10
        sqrtN10 = sqrtN10 * 10
        if (sqrtN > 10 * n) break
    }
}

System.print("Test 1 .. 49")
for (i in 1..49) {
    var t = lowSquareStartN.call(i)
    Fmt.write("$7d", t * t)
    if (i % 10  == 0) System.print()
}
System.print("\n")
System.print("Test 999,991 .. 1,000,000")
for (i in 999991..1e6) {
    var t = lowSquareStartN.call(i)
    Fmt.print("$10d : $10d -> $14d", i, t, t * t)
}
