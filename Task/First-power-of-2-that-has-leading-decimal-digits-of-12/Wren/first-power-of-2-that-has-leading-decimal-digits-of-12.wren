import "/fmt" for Fmt
import "/math" for Math

var ld10 = Math.ln2 / Math.ln10

var p = Fn.new { |L, n|
    var i = L
    var digits = 1
    while (i >= 10) {
        digits = digits * 10
        i = (i/10).floor
    }
    var count = 0
    i = 0
    while (count < n) {
        var e = (Math.ln10 * (i * ld10).fraction).exp
        if ((e * digits).truncate == L) count = count + 1
        i = i + 1
    }
    return i - 1
}

var start = System.clock
var params = [ [12, 1] , [12, 2], [123, 45], [123, 12345], [123, 678910] ]
for (param in params) {
    Fmt.print("p($d, $d) = $,d", param[0], param[1], p.call(param[0], param[1]))
}

System.print("\nTook %(System.clock - start) seconds.")
