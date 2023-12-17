import "./fmt" for Fmt
import "./math" for Nums
import "./sort" for Find

var humble = Fn.new { |n|
    var h = List.filled(n, 0)
    h[0] = 1
    var next2 = 2
    var next3 = 3
    var next5 = 5
    var next7 = 7
    var i = 0
    var j = 0
    var k = 0
    var l = 0
    for (m in 1...n) {
        h[m] = Nums.min([next2, next3, next5, next7])
        if (h[m] == next2) {
            i = i + 1
            next2 = 2 * h[i]
        }
        if (h[m] == next3) {
            j = j + 1
            next3 = 3 * h[j]
        }
        if (h[m] == next5) {
            k = k + 1
            next5 = 5 * h[k]
        }
        if (h[m] == next7) {
            l = l + 1
            next7 = 7 * h[l]
        }
    }
    return h
}

var n = 43000 // say
var h = humble.call(n)
System.print("The first 50 humble numbers are:")
System.print(h[0..49])

var f = Find.all(h, Num.maxSafeInteger) // binary search
var maxUsed = f[0] ? f[2].min + 1 : f[2].min
var maxDigits = 16 // Num.maxSafeInteger (2^53 -1) has 16 digits
var counts = List.filled(maxDigits + 1, 0)
var digits = 1
var pow10 = 10
for (i in 0...maxUsed) {
    while (true) {
        if (h[i] >= pow10) {
            pow10 = pow10 * 10
            digits = digits + 1
        } else break
    }
    counts[digits] = counts[digits] + 1
}
System.print("\nOf the first %(Fmt.dc(0, maxUsed)) humble numbers:")
for (i in 1..maxDigits) {
    var s = (i != 1) ? "s" : ""
    System.print("%(Fmt.dc(9, counts[i])) have %(Fmt.d(2, i)) digit%(s)")
}
