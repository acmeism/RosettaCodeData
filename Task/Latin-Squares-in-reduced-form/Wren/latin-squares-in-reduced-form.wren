import "/sort" for Sort
import "/math" for Int
import "/fmt" for Fmt

// generate derangements of first n numbers, with 'start' in first place.
var dList = Fn.new { |n, start|
    var r = []
    start = start - 1 // use 0 basing
    var a = [0] * n
    for (i in 1...n) a[i] = i
    a[start] = a[0]
    a[0] = start
    Sort.quick(a, 1, a.count - 1, false)
    var first = a[1]
    var recurse // recursive closure permutes a[1..-1]
    recurse = Fn.new { |last|
        if (last == first) {
            // bottom of recursion.  you get here once for each permutation.
            // test if permutation is deranged.
            var j = 1
            for (v in a.skip(1)) {
                if (j == v) return // no, ignore it
                j = j + 1
            }
            // yes, save a copy
            var b = a.toList
            for (i in 0...b.count) b[i] = b[i] + 1  // change back to 1 basing
            r.add(b)
            return
        }
        var i = last
        while (i >= 1) {
            var t = a[i]
            a[i] = a[last]
            a[last] = t
            recurse.call(last-1)
            t = a[i]
            a[i] = a[last]
            a[last] = t
            i = i - 1
        }
    }
    recurse.call(n-1)
    return r
}

var printSquare = Fn.new { |latin, n|
    System.print(latin.join("\n"))
    System.print()
}

var reducedLatinSquare = Fn.new { |n, echo|
    if (n <= 0) {
        if (echo) System.print("[]\n")
        return 0
    }
    if (n == 1) {
        if (echo) System.print("[1]\n")
        return 1
    }
    var rlatin = List.filled(n, null)
    for (i in 0...n) rlatin[i] = List.filled(n, 0)
    // first row
    for (j in 0...n) rlatin[0][j] = j + 1
    var count = 0
    var recurse // // recursive closure to compute reduced latin squares and count or print them
    recurse = Fn.new { |i|
        var rows = dList.call(n, i) // get derangements of first n numbers, with 'i' first.
        for (r in 0...rows.count) {
            var outer = false
            for (rr in 0...rows[r].count) rlatin[i-1][rr] = rows[r][rr]
            var k = 0
            while (k < i-1) {
                var j = 1
                while (j < n) {
                    if (rlatin[k][j] == rlatin[i-1][j]) {
                        if (r < rows.count - 1) {
                            outer = true
                            break
                        } else if (i > 2) {
                            return
                        }
                    }
                    j = j + 1
                }
                if (outer) break
                k = k + 1
            }
            if (!outer) {
                if (i < n) {
                    recurse.call(i + 1)
                } else {
                    count = count + 1
                    if (echo) printSquare.call(rlatin, n)
                }
            }
        }
    }

    // remaining rows
    recurse.call(2)
    return count
}

System.print("The four reduced latin squares of order 4 are:\n")
reducedLatinSquare.call(4, true)

System.print("The size of the set of reduced latin squares for the following orders")
System.print("and hence the total number of latin squares of these orders are:\n")
for (n in 1..6) {
    var size = reducedLatinSquare.call(n, false)
    var f = Int.factorial(n-1)
    f = f * f * n * size
    Fmt.print("Order $d: Size $-4d x $d! x $d! => Total $d", n, size, n, n-1, f)
}
