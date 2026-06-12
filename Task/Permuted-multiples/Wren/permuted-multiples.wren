import "./math" for Int

// assumes l1 is sorted but l2 is not
var areSame = Fn.new { |l1, l2|
    if (l1.count != l2.count) return false
    l2.sort()
    for (i in 0...l1.count) {
        if (l1[i] != l2[i]) return false
    }
    return true
}

var i = 100  // clearly a 1 or 2 digit number is impossible
var nextPow = 1000
while (true) {
    var digits = Int.digits(i)
    if (digits[0] != 1) {
        i = nextPow
        nextPow = nextPow * 10
        continue
    }
    digits.sort()
    var allSame = true
    for (j in 2..6) {
        var digits2 = Int.digits(i * j)
        if (!areSame.call(digits, digits2)) {
            allSame = false
            break
        }
    }
    if (allSame) {
        System.print("The smallest positive integer n for which the following")
        System.print("multiples contain exactly the same digits is:")
        System.print("    n = %(i)")
        for (k in 2..6) System.print("%(k) x n = %(k * i)")
        return
    }
    i = i + 1
}
