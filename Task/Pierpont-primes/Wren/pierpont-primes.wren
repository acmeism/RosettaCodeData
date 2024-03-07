import "./big" for BigInt
import "./fmt" for Fmt

var pierpont = Fn.new { |n, first|
    var p = [ List.filled(n, null), List.filled(n, null) ]
    for (i in 0...n) {
        p[0][i] = BigInt.zero
        p[1][i] = BigInt.zero
    }
    p[0][0] = BigInt.two
    var count  = 0
    var count1 = 1
    var count2 = 0
    var s = [BigInt.one]
    var i2 = 0
    var i3 = 0
    var k  = 1
    while (count < n) {
        var n2 = s[i2] * 2
        var n3 = s[i3] * 3
        var t
        if (n2 < n3) {
            t = n2
            i2 = i2 + 1
        } else {
            t = n3
            i3 = i3 + 1
        }
        if (t > s[k-1]) {
            s.add(t.copy())
            k = k + 1
            t = t.inc
            if (count1 < n && t.isProbablePrime(5)) {
                p[0][count1] = t.copy()
                count1 = count1 + 1
            }
            t = t - 2
            if (count2 < n && t.isProbablePrime(5)) {
                p[1][count2] = t.copy()
                count2 = count2 + 1
            }
            count = count1.min(count2)
        }
    }
    return p
}

var p = pierpont.call(250, true)
System.print("First 50 Pierpont primes of the first kind:")
for (i in 0...50) {
    Fmt.write("$8i ", p[0][i])
    if ((i-9)%10 == 0) System.print()
}
System.print("\nFirst 50 Pierpont primes of the second kind:")
for (i in 0...50) {
    Fmt.write("$8i ", p[1][i])
    if ((i-9)%10 == 0) System.print()
}

System.print("\n250th Pierpont prime of the first kind: %(p[0][249])")
System.print("\n250th Pierpont prime of the second kind: %(p[1][249])")
