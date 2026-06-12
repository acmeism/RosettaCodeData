var maxLen = 13
var maxNonBrauer = 191

var isBrauer = Fn.new { |a|
    for (i in 2...a.count) {
        var ok = false
        for (j in i-1..0) {
            if (a[i-1] + a[j] == a[i]) {
                ok = true
                break
            }
        }
        if (!ok) return false
    }
    return true
}

var brauerCount = 0
var nonBrauerCount = 0
var brauerExample = ""
var nonBrauerExample = ""

var additionChains // recursive
additionChains = Fn.new { |target, length, chosen|
    var le = chosen.count
    var last = chosen[-1]
    if (last == target) {
        if (le < length) {
            brauerCount = 0
            nonBrauerCount = 0
        }
        if (isBrauer.call(chosen)) {
            brauerCount = brauerCount + 1
            brauerExample = chosen.toString
        } else {
            nonBrauerCount = nonBrauerCount + 1
            nonBrauerExample = chosen.toString
        }
        return le
    }
    if (le == length) return length
    if (target > maxNonBrauer) {
        for (i in le-1..0) {
            var next = last + chosen[i]
            if (next <= target && next > chosen[-1] && i < length) {
                length = additionChains.call(target, length, chosen + [next])
            }
        }
    } else {
        var ndone = []
        while (true) {
            for (i in le-1..0) {
                var next = last + chosen[i]
                if (next <= target && next > chosen[-1] && i < length &&
                    !ndone.contains(next)) {
                    ndone.add(next)
                    length = additionChains.call(target, length, chosen + [next])
                }
            }
            le = le - 1
            if (le == 0) break
            last = chosen[le-1]
        }
    }
    return length
}

var start = System.clock
var nums = [7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379]
System.print("Searching for Brauer chains up to a minimum length of %(maxLen-1)")
for (num in nums) {
    brauerCount = 0
    nonBrauerCount = 0
    var le = additionChains.call(num, maxLen, [1])
    System.print("\nN = %(num)")
    System.print("Minimum length of chains : L(%(num)) = %(le-1)")
    System.print("Number of minimum length Brauer chains : %(brauerCount)")
    if (brauerCount > 0) {
        System.print("Brauer example : %(brauerExample)")
    }
    if (num <= maxNonBrauer) {
        System.print("Number of minimum length non-Brauer chains : %(nonBrauerCount)")
        if (nonBrauerCount > 0) {
            System.print("Non-Brauer example : %(nonBrauerExample)")
        }
    } else System.print("Non-Brauer analysis suppressed")
}
System.print("\nTook %(System.clock - start) seconds.")
