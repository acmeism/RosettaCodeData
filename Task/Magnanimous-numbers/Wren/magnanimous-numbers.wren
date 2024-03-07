import "./fmt" for Conv, Fmt
import "./math" for Int

var isMagnanimous = Fn.new { |n|
    if (n < 10) return true
    var p = 10
    while (true) {
        var q = (n/p).floor
        var r = n % p
        if (!Int.isPrime(q + r)) return false
        if (q < 10) break
        p = p * 10
    }
    return true
}

var listMags = Fn.new { |from, thru, digs, perLine|
    if (from < 2) {
        System.print("\nFirst %(thru) magnanimous numbers:")
    } else {
        System.print("\n%(Conv.ord(from)) through %(Conv.ord(thru)) magnanimous numbers:")
    }
    var i = 0
    var c = 0
    while (c < thru) {
        if (isMagnanimous.call(i)) {
            c = c + 1
            if (c >= from) {
                System.write(Fmt.d(digs, i) + " ")
                if (c % perLine == 0) System.print()
            }
        }
        i = i + 1
    }
}

listMags.call(1, 45, 3, 15)
listMags.call(241, 250, 1, 10)
listMags.call(391, 400, 1, 10)
