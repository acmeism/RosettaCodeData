import "./math" for Int
import "./fmt" for Conv, Fmt

var primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]
var digits = "123456789ABCD"

for (b in 9..14) {
    var master = 1
    for (d in 1...b) master = master * primes[d-1]
    var phd = []
    var min = Conv.atoi(digits[0..(b-2)], b).sqrt.ceil
    var max = Conv.atoi(digits[(b-2)..0], b).sqrt.floor
    var div = Int.primeFactors(b-1)[-1]
    for (i in min..max) {
        if ((i % div) != 0) continue
        var sq = i * i
        var digs = Int.digits(sq, b)
        if (digs.contains(0)) continue
        var key = 1
        for (dig in digs) key = key * primes[dig-1]
        if (key == master) phd.add(i)
    }
    System.print("There is a total of %(phd.count) penholodigital squares in base %(b):")
    if (b > 13) phd = [phd[0], phd[-1]]
    for (i in 0...phd.count) {
        Fmt.write("$s² = $s  ", Conv.Itoa(phd[i], b), Conv.Itoa(phd[i] * phd[i], b))
        if ((i + 1) % 3 == 0) System.print()
    }
    if (phd.count % 3 != 0) System.print()
    System.print()
}
