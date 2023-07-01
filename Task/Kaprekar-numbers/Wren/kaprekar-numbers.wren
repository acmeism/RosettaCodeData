import "/fmt" for Fmt, Conv

var kaprekar = Fn.new { |n, base|
    var order = 0
    if (n == 1) return [true, -1]
    var nn = n * n
    var power = 1
    while (power <= nn) {
        power = power * base
        order = order + 1
    }
    power = (power/base).floor
    order = order - 1
    while (power > 1) {
        var q = (nn/power).floor
        var r = nn % power
        if (q >= n) return [false, -1]
        if (q + r == n) return [true, order]
        order = order - 1
        power = (power/base).floor
    }
    return [false, -1]
}

var max = 1e4
System.print("Kaprekar numbers < %(max):")
for (m in 0...max) {
    var res = kaprekar.call(m, 10)
    if (res[0]) Fmt.print("$6d", m)
}

max = 1e6
var count = 0
for (m in 0...max) {
    var res = kaprekar.call(m, 10)
    if (res[0]) count = count + 1
}
System.print("\nThere are %(count) Kaprekar numbers < %(max).")

var base = 17
var maxB = 1e6.toString
System.print("\nKaprekar numbers between 1 and %(maxB)(base %(base)):")
max = Conv.atoi(maxB, base)
Fmt.print("\n Base 10  Base $d        Square       Split", base)
for (m in 2...max) {
    var res = kaprekar.call(m, base)
    if (res[0]) {
        var sq = Conv.itoa(m*m, base)
        var str = Conv.itoa(m, base)
        var split = sq.count - res[1]
        Fmt.print("$8d  $7s  $12s  $6s + $s", m, str, sq, sq[0...split], sq[split..-1])
    }
}
