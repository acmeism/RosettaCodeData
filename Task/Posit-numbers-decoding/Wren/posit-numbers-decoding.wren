import "./fmt" for Conv, Fmt
import "./big" for BigRat, BigInt

var positDecode = Fn.new { |ps, maxExpSize|
    var p = ps.map { |c| c == "0" ? 0 : 1 }.toList

    // Deal with exceptional values.
    if (p[1..-1].all { |i| i == 0 }) {
        return (p[0] == 0) ? BigRat.zero : Conv.infinity
    }

    // Convert bits after sign bit to two's complement if negative.
    var n = p.count
    if (p[0] == 1) {
        for (i in 1...n) p[i] = (p[i] == 0) ? 1 : 0
        for (i in n-1..1) {
            if (p[i] == 1) {
                p[i] = 0
            } else {
                p[i] = 1
                break
            }
        }
    }
    var first = p[1]
    var rs = n - 1  // regime size
    for (i in 2...n) {
        if (p[i] != first) {
            rs = i - 1
            break
        }
    }
    var regime = p[1..rs]
    var es = (rs == n - 1) ? 0 : maxExpSize.min(n - 2 -rs)  // actual exponent size
    var exponent = [0]
    if (es > 0) exponent = p[rs + 2...rs + 2 + es]
    var fs = (es == 0) ? 0 : n - 2 - rs - es  // function size
    var s = (p[0] == 0) ? 1 : -1  // sign
    var k = regime.all { |i| i == 0 } ? -rs : rs - 1
    var u = BigInt.two.pow(2.pow(maxExpSize))
    var e = Conv.atoi(exponent.join(""), 2)
    var f = BigRat.one
    if (fs > 0) {
        var fraction = p.join("")[-fs..-1]
        f = Conv.atoi(fraction, 2)
        f = BigRat.one + BigRat.new(f, 2.pow(fs))
    }
    return f * BigRat.new(u, 1).pow(k) * s * 2.pow(e)
}

var tests = [
    [3, "0000110111011101"],
    [3, "1000000000000000"],
    [3, "0000000000000000"],
    [1, "0110110010101000"],
    [1, "1001001101011000"],
    [2, "0000000000000001"],
    [0, "0111111111111111"],
    [6, "0111111111111110"],
    [1, "01000000"],
    [1, "11000000"],
    [1, "00110000"],
    [1, "00100000"],
    [2, "00000001"],
    [2, "01111111"],
    [7, "01111110"],
    [2, "00000000000000000000000000000001"],
    [2, "01111111111111111111111111111111"],
    [5, "01111111111111111111111111111110"]
]

for (test in tests) {
    var res = positDecode.call(test[1], test[0])
    var res2 = (res is BigRat) ? res.toFloat : Num.infinity
    Fmt.print("$s(es = $d) -> $s or $n", test[1], test[0], res, res2)
}
