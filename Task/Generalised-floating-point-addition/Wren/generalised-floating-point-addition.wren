import "./big" for BigRat
import "./fmt" for Fmt

var repeatedAdd = Fn.new { |br, times|
    var sum = BigRat.zero
    for (i in 0...times) sum = sum + br
    return sum
}

var s = "12345679"
var t = "123456790"
var e = 63
var ans = BigRat.fromDecimal("1e72")
for (n in -7..21) {
    var br = BigRat.fromDecimal("%(s)e%(e)")
    var oneE = BigRat.fromDecimal("1e%(e)")
    var temp = repeatedAdd.call(br, 9)
    var res = repeatedAdd.call(temp, 9) + oneE
    Fmt.print("$2d : 1e72? $s", n, res == ans)
    s = t + s
    e = e - 9
}
