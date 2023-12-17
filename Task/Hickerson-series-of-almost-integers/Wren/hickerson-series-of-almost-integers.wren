import "./fmt" for Fmt
import "./big" for BigInt, BigDec

var hickerson = Fn.new { |n|
    var fact = BigDec.fromBigInt(BigInt.factorial(n), 64)
    var ln2 = BigDec.ln2 // precise to 64 decimal digits
    return fact / (BigDec.two * ln2.pow(n+1))
}

System.print("Values of h(n), truncated to 1 dp, and whether 'almost integers' or not:")
for (i in 1..17) {
    // truncate to 1 d.p and show final zero if any
    var h = hickerson.call(i).toString(1, false, true)
    var k = h.count - 1
    var ai = (h[k] == "0" || h[k] == "9")
    Fmt.print("$2d: $20s $s", i, h, ai)
}
