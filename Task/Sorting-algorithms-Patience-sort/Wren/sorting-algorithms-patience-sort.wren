import "./sort" for Cmp

var patienceSort = Fn.new { |a|
    var size = a.count
    if (size < 2) return
    var cmp = Cmp.default(a[0])
    var piles = []
    for (e in a) {
        var outer = false
        for (pile in piles) {
            if (cmp.call(pile[-1], e) > 0) {
                pile.add(e)
                outer = true
                break
            }
        }
        if (!outer) piles.add([e])
    }
    for (i in 0...size) {
        var min = piles[0][-1]
        var minPileIndex = 0
        for (j in 1...piles.count) {
            if (cmp.call(piles[j][-1], min) < 0) {
                min = piles[j][-1]
                minPileIndex = j
            }
        }
        a[i] = min
        var minPile = piles[minPileIndex]
        minPile.removeAt(-1)
        if (minPile.count == 0) piles.removeAt(minPileIndex)
    }
}

var ia = [4, 65, 2, -31, 0, 99, 83, 782, 1]
patienceSort.call(ia)
System.print(ia)

var ca = ["n", "o", "n", "z", "e", "r", "o", "s", "u", "m"]
patienceSort.call(ca)
System.print(ca)

var sa = ["dog", "cow", "cat", "ape", "ant", "man", "pig", "ass", "gnu"]
patienceSort.call(sa)
System.print(sa)
