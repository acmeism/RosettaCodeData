import "./dynamic" for Struct
import "./long" for ULong
import "./big" for BigInt
import "./math" for Math

var Logrep = Struct.create("LogRep", ["lg", "x2", "x3", "x5"])

var nthHamming = Fn.new { |n|
    if (n < 2) {
        if (n < 1) Fiber.abort("nthHamming:  argument is zero!")
        return [0, 0, 0]
    }
    var lb3   = 1.5849625007211561814537389439478
    var lb5   = 2.3219280948873623478703194294894
    var fctr  = 6 * lb3 * lb5
    var crctn = 2.4534452978042592646620291867186
    var lgest = (n.toNum * fctr).cbrt - crctn
    var frctn = (n < 1000000000) ? 0.509 : 0.106
    var lghi = ((n.toNum + lgest * frctn) * fctr).cbrt - crctn
    var lglo = lgest * 2 - lghi
    var count = ULong.zero
    var bnd = []
    var klmt = (lghi/lb5).truncate.abs + 1
    for (k in 0...klmt) {
        var p = k * lb5
        var jlmt = ((lghi - p)/lb3).truncate.abs + 1
        for (j in 0...jlmt) {
            var q = p + j * lb3
            var ir = lghi - q
            var lg = q + ir.floor
            count = count + ir.truncate.abs + 1
            if (lg >= lglo) bnd.add(Logrep.new(lg, ir.truncate.abs, j, k))
        }
    }
    if (n > count) Fiber.abort("nthHamming:  band high estimate is too low!")
    var ndx = (count - n).toSmall
    if (ndx >= bnd.count) Fiber.abort("nthHamming:  band low estimate is too high!")
    bnd.sort { |a, b| b.lg < a.lg }
    var rslt = bnd[ndx]
    return [rslt.x2, rslt.x3, rslt.x5]
}

var convertTpl2BigInt = Fn.new { |tpl|
    var result = BigInt.one
    for (i in 0...tpl[0]) result = result * 2
    for (i in 0...tpl[1]) result = result * 3
    for (i in 0...tpl[2]) result = result * 5
    return result
}

System.print("The first 20 Hamming numbers are:")
for (i in 1..20) {
    System.write("%(convertTpl2BigInt.call(nthHamming.call(ULong.new(i)))) ")
}
System.print("\n\nThe 1,691st Hamming number is:")
System.print(convertTpl2BigInt.call(nthHamming.call(ULong.new(1691))))
var start = System.clock
var res = nthHamming.call(ULong.new(1e6))
var end = System.clock
System.print("\nThe 1,000,000 Hamming number is:")
System.print(convertTpl2BigInt.call(res))
var duration = ((end-start) * 1000).round
System.print("The last of these found in %(duration) milliseconds.")
