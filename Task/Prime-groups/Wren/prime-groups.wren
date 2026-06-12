import "./perm" for Comb
import "./math" for Int

var tests = ["riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja"]

System.print("Groups of 3 letters:")
for (test in tests) {
    var res = []
    for (comb in Comb.list(test.toList, 3)) {
        var allPrime = true
        for (pair in Comb.list(comb, 2)) {
            var delta = (pair[0].codePoints[0] - pair[1].codePoints[0]).abs
            if (!Int.isPrime(delta)) {
                allPrime = false
                break
            }
        }
        if (allPrime) res.add(comb)
    }
    if (res.count > 0) {
        System.print(res[0].join(""))
    } else {
        System.print("Not found.")
    }
}

System.print("\nGroups of 2 letters:")
for (test in tests) {
    var res = []
    for (pair in Comb.list(test.toList, 2)) {
        var delta = (pair[0].codePoints[0] - pair[1].codePoints[0]).abs
        if (Int.isPrime(delta)) res.add(pair)
    }
    if (res.count > 0) {
        System.print(res[0].join(""))
    } else {
        System.print("Not found.")
    }
}
