import "./long" for ULong
import "./fmt" for Conv, Fmt

var firstOneTwo = Fn.new { |n|
    var k = ULong.new("1" * n)
    var r = (ULong.one << n) - 1
    var m = 0
    while (r >= m) {
        var t = k + ULong.new(Conv.bin(m))
        if (t.isPrime) return t
        m = m + 1
    }
    return ULong.zero
}

for (n in 1..20) Fmt.print("$2d: $i", n, firstOneTwo.call(n))
