import "random" for Random
import "./math" for Int
import "./fmt" for Fmt

var genFactBaseNums = Fn.new { |size, countOnly|
    var results = []
    var count = 0
    var n = 0
    while (true) {
        var radix = 2
        var res = null
        if (!countOnly) res = List.filled(size, 0)
        var k = n
        while (k > 0) {
            var div = (k/radix).floor
            var rem = k % radix
            if (!countOnly) {
                if (radix <= size + 1) res[size-radix+1] = rem
            }
            k = div
            radix = radix + 1
         }
         if (radix > size+2) break
         count = count + 1
         if (!countOnly) results.add(res)
         n = n + 1
    }
    return [results, count]
}

var mapToPerms = Fn.new { |factNums|
    var perms = []
    var psize = factNums[0].count + 1
    var start = List.filled(psize, 0)
    for (i in 0...psize) start[i] = i
    for (fn in factNums) {
        var perm = start.toList
        for (m in 0...fn.count) {
            var g = fn[m]
            if (g != 0) {
                var first = m
                var last = m + g
                for (i in 1..g) {
                    var temp = perm[first]
                    for (j in first+1..last) perm[j-1] = perm[j]
                    perm[last] = temp
                }
            }
        }
        perms.add(perm)
    }
    return perms
}

var join = Fn.new { |ints, sep| ints.map { |i| i.toString }.join(sep) }

var undot = Fn.new { |s| s.split(".").map { |ss| Num.fromString(ss) }.toList }

var rand = Random.new()

// Recreate the table.
var factNums = genFactBaseNums.call(3, false)[0]
var perms = mapToPerms.call(factNums)
var i = 0
for (fn in factNums) {
    Fmt.print("$s -> $s", join.call(fn, "."), join.call(perms[i], ""))
    i = i + 1
}

// Check that the number of perms generated is equal to 11! (this takes a while).
var count = genFactBaseNums.call(10, true)[1]
Fmt.print("\nPermutations generated = $,d", count)
Fmt.print("compared to 11! which  = $,d", Int.factorial(11))
System.print()

// Generate shuffles for the 2 given 51 digit factorial base numbers.
var fbn51s = [
    "39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0",
    "51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1"
]
factNums = [undot.call(fbn51s[0]), undot.call(fbn51s[1])]
perms = mapToPerms.call(factNums)
var shoe = "A♠K♠Q♠J♠T♠9♠8♠7♠6♠5♠4♠3♠2♠A♥K♥Q♥J♥T♥9♥8♥7♥6♥5♥4♥3♥2♥A♦K♦Q♦J♦T♦9♦8♦7♦6♦5♦4♦3♦2♦A♣K♣Q♣J♣T♣9♣8♣7♣6♣5♣4♣3♣2♣".toList
var cards = List.filled(52, null)
for (i in 0..51) {
    cards[i] = shoe[2*i..2*i+1].join()
    if (cards[i][0] == "T") cards[i] = "10" + cards[i][1..-1]
}
i = 0
for (fbn51 in fbn51s) {
    System.print(fbn51)
    for (d in perms[i]) System.write(cards[d])
    System.print("\n")
    i = i + 1
}

// Create a random 51 digit factorial base number and produce a shuffle from that.
var fbn51 = List.filled(51, 0)
for (i in 0..50) fbn51[i] = rand.int(52-i)
System.print(join.call(fbn51, "."))
perms = mapToPerms.call([fbn51])
for (d in perms[0]) System.write(cards[d])
System.print()
