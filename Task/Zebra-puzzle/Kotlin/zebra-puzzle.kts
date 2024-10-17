// version 1.1.3

fun nextPerm(perm: IntArray): Boolean {
    val size = perm.size
    var k = -1
    for (i in size - 2 downTo 0) {
        if (perm[i] < perm[i + 1]) {
            k = i
            break
        }
    }
    if (k == -1) return false  // last permutation
    for (l in size - 1 downTo k) {
        if (perm[k] < perm[l]) {
           val temp = perm[k]
           perm[k] = perm[l]
           perm[l] = temp
           var m = k + 1
           var n = size - 1
           while (m < n) {
               val temp2 = perm[m]
               perm[m++] = perm[n]
               perm[n--] = temp2
           }
           break
        }
    }
    return true
}

fun check(a1: Int, a2: Int, v1: Int, v2: Int): Boolean {
    for (i in 0..4)
        if (p[a1][i] == v1) return p[a2][i] == v2
    return false
}

fun checkLeft(a1: Int, a2: Int, v1: Int, v2: Int): Boolean {
    for (i in 0..3)
        if (p[a1][i] == v1) return p[a2][i + 1] == v2
    return false
}

fun checkRight(a1: Int, a2: Int, v1: Int, v2: Int): Boolean {
    for (i in 1..4)
        if (p[a1][i] == v1) return p[a2][i - 1] == v2
    return false
}

fun checkAdjacent(a1: Int, a2: Int, v1: Int, v2: Int): Boolean {
    return checkLeft(a1, a2, v1, v2) || checkRight(a1, a2, v1, v2)
}

val colors  = listOf("Red", "Green", "White", "Yellow", "Blue")
val nations = listOf("English", "Swede", "Danish", "Norwegian", "German")
val animals = listOf("Dog", "Birds", "Cats", "Horse", "Zebra")
val drinks  = listOf("Tea", "Coffee", "Milk", "Beer", "Water")
val smokes  = listOf("Pall Mall", "Dunhill", "Blend", "Blue Master", "Prince")

val p = Array(120) { IntArray(5) { -1 } } //  stores all permutations of numbers 0..4

fun fillHouses(): Int {
    var solutions = 0
    for (c in 0..119) {
        if (!checkLeft(c, c, 1, 2)) continue                      // C5 : Green left of white
        for (n in 0..119) {
            if (p[n][0] != 3) continue                            // C10: Norwegian in First
            if (!check(n, c, 0, 0)) continue                      // C2 : English in Red
            if (!checkAdjacent(n, c, 3, 4)) continue              // C15: Norwegian next to Blue
            for (a in 0..119) {
                if (!check(a, n, 0, 1)) continue                  // C3 : Swede has Dog
                for (d in 0..119) {
                    if (p[d][2] != 2) continue                    // C9 : Middle drinks Milk
                    if (!check(d, n, 0, 2)) continue              // C4 : Dane drinks Tea
                    if (!check(d, c, 1, 1)) continue              // C6 : Green drinks Coffee
                    for (s in 0..119) {
                        if (!check(s, a, 0, 1)) continue          // C7 : Pall Mall has Birds
                        if (!check(s, c, 1, 3)) continue          // C8 : Yellow smokes Dunhill
                        if (!check(s, d, 3, 3)) continue          // C13: Blue Master drinks Beer
                        if (!check(s, n, 4, 4)) continue          // C14: German smokes Prince
                        if (!checkAdjacent(s, a, 2, 2)) continue  // C11: Blend next to Cats
                        if (!checkAdjacent(s, a, 1, 3)) continue  // C12: Dunhill next to Horse
                        if (!checkAdjacent(s, d, 2, 4)) continue  // C16: Blend next to Water
                        solutions++
                        printHouses(c, n, a, d, s)
                    }
                }
            }
        }
    }
    return solutions
}

fun printHouses(c: Int, n: Int, a: Int, d: Int, s: Int) {
    var owner: String = ""
    println("House  Color   Nation     Animal  Drink   Smokes")
    println("=====  ======  =========  ======  ======  ===========")
    for (i in 0..4) {
        val f = "%3d    %-6s  %-9s  %-6s  %-6s  %-11s\n"
        System.out.printf(f, i + 1, colors[p[c][i]], nations[p[n][i]], animals[p[a][i]], drinks[p[d][i]], smokes[p[s][i]])
        if (animals[p[a][i]] == "Zebra") owner = nations[p[n][i]]
    }
    println("\nThe $owner owns the Zebra\n")
}

fun main(args: Array<String>) {
    val perm = IntArray(5) { it }
    for (i in 0..119) {
        for (j in 0..4) p[i][j] = perm[j]
        nextPerm(perm)
    }
    val solutions = fillHouses()
    val plural = if (solutions == 1) "" else "s"
    println("$solutions solution$plural found")
}
