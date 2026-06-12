import "./dynamic" for Tuple

var Solution = Tuple.create("Solution", ["quotient", "remainder"])

var extendedSyntheticDivision = Fn.new { |dividend, divisor|
    var out = dividend.toList
    var normalizer = divisor[0]
    var separator = dividend.count - divisor.count + 1
    for (i in 0...separator) {
        out[i] = (out[i] / normalizer).truncate
        var coef = out[i]
        if (coef != 0) {
            for (j in 1...divisor.count) out[i + j] = out[i + j] - divisor[j] * coef
        }
    }
    return Solution.new(out[0...separator], out[separator..-1])
}

System.print("POLYNOMIAL SYNTHETIC DIVISION")
var n = [1, -12, 0, -42]
var d = [1, -3]
var sol = extendedSyntheticDivision.call(n, d)
System.write("%(n) / %(d)  =  ")
System.print("%(sol.quotient), remainder %(sol.remainder)")
System.print()
var n2 = [1, 0, 0, 0, -2]
var d2 = [1, 1, 1, 1]
var sol2 = extendedSyntheticDivision.call(n2, d2)
System.write("%(n2) / %(d2)  =  ")
System.print("%(sol2.quotient), remainder %(sol2.remainder)")
