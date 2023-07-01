import "./set" for Set
import "./perm" for Perm

var missingPerms = Fn.new { |input, perms|
    var s1 = Set.new()
    s1.addAll(perms)
    var perms2 = Perm.list(input).map { |p| p.join() }
    var s2 = Set.new()
    s2.addAll(perms2)
    return s2.except(s1).toList
}

var input = ["A", "B", "C", "D"]
var perms = [
    "ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD", "ADCB", "CDAB",
    "DABC", "BCAD", "CADB", "CDBA", "CBAD", "ABDC", "ADBC", "BDCA",
    "DCBA", "BACD", "BADC", "BDAC", "CBDA", "DBCA", "DCAB"
]
var missing = missingPerms.call(input, perms)
if (missing.count == 1) {
    System.print("The missing permutation is %(missing[0])")
} else {
    System.print("There are %(missing.count) missing permutations, namely:\n")
    System.print(missing)
}
