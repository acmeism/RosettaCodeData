import "/big" for BigInt
import "io" for Stdout

var calcPi = Fn.new {
    var nn = BigInt.zero
    var nr = BigInt.zero
    var q  = BigInt.one
    var r  = BigInt.zero
    var t  = BigInt.one
    var k  = BigInt.one
    var n  = BigInt.three
    var l  = BigInt.three
    var first = true
    while (true) {
        if (q * BigInt.four + r - t < n * t) {
            System.write(n)
            if (first) {
                System.write(".")
                first = false
            }
            Stdout.flush()
            nr = (r - n * t) * BigInt.ten
            n = (q * BigInt.three + r) * BigInt.ten / t  - n * BigInt.ten
            q =  q * BigInt.ten
            r = nr
        } else {
            nr = (q * BigInt.two + r) * l
            nn = (q * BigInt.new(7) * k + BigInt.two + r * l) / (t * l)
            q  = q * k
            t  = t * l
            l  = l + BigInt.two
            k  = k + BigInt.one
            n = nn.copy()
            r = nr
        }
    }
}

calcPi.call()
