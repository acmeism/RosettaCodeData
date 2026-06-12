import "./seq" for Lst

var common2 = Fn.new { |l1, l2|
    // minimize number of lookups
    var c1 = l1.count
    var c2 = l2.count
    var shortest = (c1 < c2) ? l1 : l2
    var longest = (l1 == shortest) ? l2 : l1
    longest = longest.toList // matching duplicates will be destructive
    var res = []
    for (e in shortest) {
        var ix = Lst.indexOf(longest, e)
        if (ix >= 0) {
            res.add(e)
            longest.removeAt(ix)
        }
    }
    return res
}

var commonN = Fn.new { |ll|
    var n = ll.count
    if (n == 0) return ll
    if (n == 1) return ll[0]
    var first2 = common2.call(ll[0], ll[1])
    if (n == 2) return first2
    return ll.skip(2).reduce(first2) { |acc, l| common2.call(acc, l) }
}

var lls = [
    [[2, 5, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 9, 8, 4], [1, 3, 7, 6, 9]],
    [[2, 2, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 2, 2, 4], [2, 3, 7, 6, 2]]
]

for (ll in lls) {
    System.print("Intersection of %(ll) is:")
    System.print(commonN.call(ll))
    System.print()
}
