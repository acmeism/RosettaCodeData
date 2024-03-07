import "random" for Random
import "./sort" for Sort
import "./fmt" for Fmt
import "./math" for Int

var rand = Random.new()
var counts = List.filled(4, 0)
var aa = List.filled(16, 0)

var testSquares = [
    [0, 1, 2, 3, 1, 0, 3, 2, 2, 3, 0, 1, 3, 2, 1, 0],
    [0, 1, 2, 3, 1, 0, 3, 2, 2, 3, 1, 0, 3, 2, 0, 1],
    [0, 1, 2, 3, 1, 2, 3, 0, 2, 3, 0, 1, 3, 0, 1, 2],
    [0, 1, 2, 3, 1, 3, 0, 2, 2, 0, 3, 1, 3, 2, 1, 0]
]

// Checks whether two lists contain the same elements in the same order
var areSame = Fn.new { |l1, l2|
    if (l1.count != l2.count) return false
    for (i in 0...l1.count) {
        if (l1[i] != l2[i]) return false
    }
    return true
}

// generate derangements of first n numbers, with 'start' in first place.
var dList = Fn.new { |n, start|
    var r = []
    start = start - 1  // use 0 basing
    var a = List.filled(n, 0)
    for (i in 0...n) a[i] = i
    var t = a[0]
    a[0] = start
    a[start] = t
    Sort.quick(a, 1, a.count-1, null)
    var first = a[1]
    var recurse  // recursive closure permutes a[1..-1]
    recurse = Fn.new { |last|
        if (last == first) {
            // bottom of recursion.  you get here once for each permutation.
            // test if permutation is deranged.
            var j = 0  // j starts from 0, not 1
            for (v in a.skip(1)) {
                if (j+1 == v) return r  // no, ignore it
                j = j + 1
            }
            // yes, save a copy
            var b = a.toList
            for (i in 0...b.count) b[i] = b[i] + 1  // change back to 1 basing
            r.add(b)
            return r
        }
        var i = last
        while (i >= 1) {
            a.swap(i, last)
            recurse.call(last - 1)
            a.swap(i, last)
            i = i - 1
        }
    }
    recurse.call(n - 1)
    return r
}

var copyMatrix = Fn.new { |m|
    var le = m.count
    var cpy = List.filled(le, null)
    for (i in 0...le) cpy[i] = m[i].toList
    return cpy
}

var reducedLatinSquares = Fn.new { |n|
    var rls = []
    if (n < 0) n = 0
    var rlatin = List.filled(n, null)
    for (i in 0...n) rlatin[i] = List.filled(n, 0)
    if (n <= 1) {
        rls.add(rlatin)
        return rls
    }

    // first row
    for (j in 0...n) rlatin[0][j] = j + 1

    // recursive closure to compute reduced latin squares
    var recurse
    recurse = Fn.new { |i|
        var rows = dList.call(n, i) // get derangements of first n numbers, with 'i' first.
        for (r in 0...rows.count) {
            var outer = false
            rlatin[i-1] = rows[r].toList
            for (k in 0...i-1) {
                for (j in 1...n) {
                    if (rlatin[k][j] == rlatin[i-1][j]) {
                        if (r < rows.count-1) {
                            outer = true
                            break
                        } else if (i > 2) {
                            return
                        }
                    }
                }
                if (outer) break
            }
            if (outer) continue
            if (i < n) {
                recurse.call(i + 1)
            } else {
                var rl = copyMatrix.call(rlatin)
                rls.add(rl)
            }
        }
        return
    }

    // remaining rows
    recurse.call(2)
    return rls
}

var printSquare = Fn.new { |latin, n|
    for (i in 0...n) {
        for (j in 0...n) Fmt.write("$d ", latin[i][j]-1)
        System.print()
    }
    System.print()
}

// generate permutations of first n numbers, starting from 0.
var pList = Fn.new { |n|
    var fact  = Int.factorial(n)
    var perms = List.filled(fact, null)
    var a = List.filled(n, 0)
    for (i in 0...n) a[i] = i
    var t = a.toList
    perms[0] = t
    n = n - 1
    for (c in 1...fact) {
        var i = n - 1
        var j = n
        while (a[i] > a[i+1]) i = i - 1
        while (a[j] < a[i])   j = j - 1
        a.swap(i, j)
        j = n
        i = i + 1
        while (i < j) {
            a.swap(i, j)
            i = i + 1
            j = j - 1
        }
        var t = a.toList
        t.add(0)
        perms[c] = t
    }
    return perms
}

var generateLatinSquares = Fn.new { |n, tests, echo|
    var rls = reducedLatinSquares.call(n)
    var perms  = pList.call(n)
    var perms2 = pList.call(n - 1)
    for (test in 0...tests) {
        var rn = rand.int(rls.count)
        var rl = rls[rn] // select reduced random square at random
        rn = rand.int(perms.count)
        var rp = perms[rn] // select a random permuation of 'rl's columns
        // permute columns
        var t = List.filled(n, null)
        for (i in 0...n) {
            t[i] = List.filled(n, 0)
            for (j in 0...n) t[i][j] = rl[i][rp[j]]
        }
        rn = rand.int(perms2.count)
        rp = perms2[rn] // select a random permutation of 't's rows 2 to n
        // permute rows 2 to n
        var u = List.filled(n, null)
        for (i in 0...n) {
            u[i] = List.filled(n, 0)
            for (j in 0...n) {
                if (i == 0) {
                    u[i][j] = t[i][j]
                } else {
                    u[i][j] = t[rp[i-1]+1][j]
                }
            }
        }
        if (test < echo) printSquare.call(u, n)
        if (n == 4) {
            for (i in 0..3) {
                for (j in 0..3) u[i][j] = u[i][j] - 1
            }
            for (i in 0..3) {
                for (j in 4*i...4*i+4) {
                    aa[j] = u[i][j - 4*i]
                }
            }
            for (i in 0..3) {
                if (areSame.call(testSquares[i], aa)) {
                    counts[i] = counts[i] + 1
                    break
                }
            }
        }
    }
}

System.print("Two randomly generated latin squares of order 5 are:\n")
generateLatinSquares.call(5, 2, 2)

System.print("Out of 1,000,000 randomly generated latin squares of order 4, ")
System.print("of which there are 576 instances ( => expected 1736 per instance),")
System.print("the following squares occurred the number of times shown:\n")
generateLatinSquares.call(4, 1e6, 0)
for (i in 0..3) System.print("%(testSquares[i]) : %(counts[i])")
System.print("\nA randomly generated latin square of order 6 is:\n")
generateLatinSquares.call(6, 1, 1)
