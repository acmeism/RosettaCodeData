var throwDie // recursive
throwDie = Fn.new { |nSides, nDice, s, counts|
    if (nDice == 0) {
        counts[s] = counts[s] + 1
        return
    }
    for (i in 1..nSides) throwDie.call(nSides, nDice-1, s + i, counts)
}

var beatingProbability = Fn.new { |nSides1, nDice1, nSides2, nDice2|
    var len1 = (nSides1 + 1) * nDice1
    var c1 = List.filled(len1, 0)
    throwDie.call(nSides1, nDice1, 0, c1)

    var len2 = (nSides2 + 1) * nDice2
    var c2 = List.filled(len2, 0)
    throwDie.call(nSides2, nDice2, 0, c2)

    var p12 = nSides1.pow(nDice1) * nSides2.pow(nDice2)
    var tot = 0
    for (i in 0...len1) {
        for (j in 0...i.min(len2)) {
            tot = tot + c1[i] * c2[j] / p12
        }
    }
    return tot
}

System.print(beatingProbability.call(4, 9, 6, 6))
System.print(beatingProbability.call(10, 5, 7, 6))
