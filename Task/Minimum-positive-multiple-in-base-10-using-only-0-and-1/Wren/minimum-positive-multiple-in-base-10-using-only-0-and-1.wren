import "./fmt" for Fmt
import "./big" for BigInt

var b10 = Fn.new { |n|
    if (n == 1) {
        Fmt.print("$4d: $28s  $-24d", 1, "1", 1)
        return
    }
    var n1 = n + 1
    var pow = List.filled(n1, 0)
    var val = List.filled(n1, 0)
    var count = 0
    var ten = 1
    var x = 1
    while (x < n1) {
        val[x] = ten
        for (j in 0...n1) {
            if (pow[j] != 0 && pow[(j+ten)%n] == 0 && pow[j] != x) pow[(j+ten)%n] = x
        }
        if (pow[ten] == 0) pow[ten] = x
        ten = (10*ten) % n
        if (pow[0] != 0) break
        x = x + 1
    }
    x = n
    if (pow[0] != 0) {
        var s = ""
        while (x != 0) {
            var p = pow[x%n]
            if (count > p) s = s + ("0" * (count-p))
            count = p - 1
            s = s + "1"
            x = (n + x - val[p]) % n
        }
        if (count > 0) s = s + ("0" * count)
        var mpm = BigInt.new(s)
        var mul = mpm/n
        Fmt.print("$4d: $28s  $-24i", n, s, mul)
    } else {
        System.print("Can't do it!")
    }
}

var start = System.clock
var tests = [
    [1, 10], [95, 105], [297], [576], [594], [891], [909], [999],
    [1998], [2079], [2251], [2277], [2439], [2997], [4878]
]
System.print("   n                           B10  multiplier")
System.print("----------------------------------------------")
for (test in tests) {
    var from = test[0]
    var to = from
    if (test.count == 2) to = test[1]
    for (n in from..to) b10.call(n)
}
System.print("\nTook %(System.clock-start) seconds.")
