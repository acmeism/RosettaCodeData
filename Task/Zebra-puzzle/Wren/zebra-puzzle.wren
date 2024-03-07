import "./fmt" for Fmt

var colors  = ["Red", "Green", "White", "Yellow", "Blue"]
var nations = ["English", "Swede", "Danish", "Norwegian", "German"]
var animals = ["Dog", "Birds", "Cats", "Horse", "Zebra"]
var drinks  = ["Tea", "Coffee", "Milk", "Beer", "Water"]
var smokes  = ["Pall Mall", "Dunhill", "Blend", "Blue Master", "Prince"]

var p = List.filled(120, null) //  stores all permutations of numbers 0..4
for (i in 0..119) p[i] = List.filled(5, -1)

var nextPerm = Fn.new { |perm|
    var size = perm.count
    var k = -1
    for (i in size-2..0) {
        if (perm[i] < perm[i + 1]) {
            k = i
            break
        }
    }
    if (k == -1) return false  // last permutation
    for (l in size-1..k) {
        if (perm[k] < perm[l]) {
            perm.swap(k, l)
            var m = k + 1
            var n = size - 1
            while (m < n) {
                perm.swap(m, n)
                m = m + 1
                n = n - 1
            }
            break
        }
    }
    return true
}

var check = Fn.new { |a1, a2, v1, v2|
    for (i in 0..4) {
        if (p[a1][i] == v1) return p[a2][i] == v2
    }
    return false
}

var checkLeft = Fn.new { |a1, a2, v1, v2|
    for (i in 0..3) {
        if (p[a1][i] == v1) return p[a2][i + 1] == v2
    }
    return false
}

var checkRight = Fn.new { |a1, a2, v1, v2|
    for (i in 1..4) {
        if (p[a1][i] == v1) return p[a2][i - 1] == v2
    }
    return false
}

var checkAdjacent = Fn.new { |a1, a2, v1, v2|
    return checkLeft.call(a1, a2, v1, v2) || checkRight.call(a1, a2, v1, v2)
}

var printHouses = Fn.new { |c, n, a, d, s|
    var owner = ""
    System.print("House  Color   Nation     Animal  Drink   Smokes")
    System.print("=====  ======  =========  ======  ======  ===========")
    for (i in 0..4) {
        var f = "$3d    $-6s  $-9s  $-6s  $-6s  $-11s"
        var l = [i + 1, colors[p[c][i]], nations[p[n][i]], animals[p[a][i]], drinks[p[d][i]], smokes[p[s][i]]]
        Fmt.lprint(f, l)
        if (animals[p[a][i]] == "Zebra") owner = nations[p[n][i]]
    }
    System.print("\nThe %(owner) owns the Zebra\n")
}

var fillHouses = Fn.new {
    var solutions = 0
    for (c in 0..119) {
        if (!checkLeft.call(c, c, 1, 2)) continue                      // C5 : Green left of white
        for (n in 0..119) {
            if (p[n][0] != 3) continue                                 // C10: Norwegian in First
            if (!check.call(n, c, 0, 0)) continue                      // C2 : English in Red
            if (!checkAdjacent.call(n, c, 3, 4)) continue              // C15: Norwegian next to Blue
            for (a in 0..119) {
                if (!check.call(a, n, 0, 1)) continue                  // C3 : Swede has Dog
                for (d in 0..119) {
                    if (p[d][2] != 2) continue                         // C9 : Middle drinks Milk
                    if (!check.call(d, n, 0, 2)) continue              // C4 : Dane drinks Tea
                    if (!check.call(d, c, 1, 1)) continue              // C6 : Green drinks Coffee
                    for (s in 0..119) {
                        if (!check.call(s, a, 0, 1)) continue          // C7 : Pall Mall has Birds
                        if (!check.call(s, c, 1, 3)) continue          // C8 : Yellow smokes Dunhill
                        if (!check.call(s, d, 3, 3)) continue          // C13: Blue Master drinks Beer
                        if (!check.call(s, n, 4, 4)) continue          // C14: German smokes Prince
                        if (!checkAdjacent.call(s, a, 2, 2)) continue  // C11: Blend next to Cats
                        if (!checkAdjacent.call(s, a, 1, 3)) continue  // C12: Dunhill next to Horse
                        if (!checkAdjacent.call(s, d, 2, 4)) continue  // C16: Blend next to Water
                        solutions = solutions + 1
                        printHouses.call(c, n, a, d, s)
                    }
                }
            }
        }
    }
    return solutions
}

var perm = [0, 1, 2, 3, 4]
for (i in 0..119) {
    for (j in 0..4) p[i][j] = perm[j]
    nextPerm.call(perm)
}
var solutions = fillHouses.call()
var plural = (solutions == 1) ? "" : "s"
System.print("%(solutions) solution%(plural) found")
