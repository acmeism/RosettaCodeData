import "./math" for Int, Nums
import "./set" for Set
import "./fmt" for Fmt

var isColorful = Fn.new { |n|
    if (n < 0) return false
    if (n < 10) return true
    var digits = Int.digits(n)
    if (digits.contains(0) || digits.contains(1)) return false
    var set = Set.new(digits)
    var dc = digits.count
    if (set.count < dc) return false
    for (k in 2..dc) {
        for (i in 0..dc-k) {
           var prod = 1
           for (j in i..i+k-1) prod = prod * digits[j]
           if (set.contains(prod)) return false
           set.add(prod)
        }
    }
    return true
}

var count = List.filled(9, 0)
var used  = List.filled(11, false)
var largest = 0

var countColorful // recursive
countColorful = Fn.new { |taken, n|
    if (taken == 0) {
        for (digit in 0..9) {
            var dx = digit + 1
            used[dx] = true
            countColorful.call((digit < 2) ? 9 : 1, String.fromByte(digit + 48))
            used[dx] = false
        }
    } else {
        var nn = Num.fromString(n)
        if (isColorful.call(nn)) {
            var ln = n.count
            count[ln] = count[ln] + 1
            if (nn > largest) largest = nn
        }
        if (taken < 9) {
            for (digit in 2..9) {
                var dx = digit + 1
                if (!used[dx]) {
                    used[dx] = true
                    countColorful.call(taken + 1, n + String.fromByte(digit + 48))
                    used[dx] = false
                }
            }
        }
    }
}

var cn = (0..99).where { |i| isColorful.call(i) }.toList
System.print("The %(cn.count) colorful numbers less than 100 are:")
Fmt.tprint("$2d", cn, 10)

countColorful.call(0, "")
System.print("\nThe largest possible colorful number is:")
Fmt.print("$,d\n", largest)

System.print("Count of colorful numbers for each order of magnitude:")
var pow = 10
for (dc in 1...count.count) {
    Fmt.print("  $d digit colorful number count: $,6d - $7.3f\%", dc, count[dc], 100 * count[dc] / pow)
    pow = (pow == 10) ? 90 : pow * 10
}

Fmt.print("\nTotal colorful numbers: $,d", Nums.sum(count))
