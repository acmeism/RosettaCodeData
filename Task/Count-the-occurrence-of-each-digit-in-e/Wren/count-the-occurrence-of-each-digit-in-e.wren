var countDigitsInE = Fn.new { |n|
    var v  = List.filled(n, 1)
    var dc = List.filled(10, 0)
    dc[2] = 1 // to count the non-fractional digit
    for (col in 1...2 * n) {
        var a = n + 1
        var c = 0
        for (i in 0...n) {
            c = c + v[i] * 10
            v[i] = c % a
            c = (c/a).floor
            a = a - 1
        }
        dc[c] = dc[c] + 1
    }
    for (d in 0..9) System.print("%(d): %(dc[d])")
    var t = dc.reduce { |acc, d| acc + d }
    System.print("Total digits: %(t)")
}

countDigitsInE.call(2000)
System.print()
countDigitsInE.call(3000)
