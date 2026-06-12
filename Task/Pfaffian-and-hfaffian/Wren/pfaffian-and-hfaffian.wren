import "./math" for Int
import "./fmt" for Fmt

var isAntisymmetric = Fn.new { |a|
    var n = a.count
    for (i in 0...n) {
        if (a[i][i] != 0) return false  // diagonal elments must be zero
        for (j in i + 1...n) if (a[i][j] != -a[j][i]) return false
    }
    return true
}

var spermutations = Fn.new { |n|
    var p = (0..n).toList
    var perms = [[p.toList, 1]]
    var count = 0
    for (c in 1...Int.factorial(n + 1)) {
        var i = n - 1
        var j = n
        while (p[i] > p[i+1]) i = i - 1
        while (p[j] < p[i])   j = j - 1
        p.swap(i, j)
        count = count + 1
        j = n
        i = i + 1
        while (i < j) {
            p.swap(i, j)
            count = count + 1
            i = i + 1
            j = j - 1
        }
        var sign = count % 2 == 0 ? 1 : -1
        perms.add([p.toList, sign])
    }
    return perms
}

// Compute the Pfaffian or Hfaffian of a 2n x 2n antisymmetric matrix.
var faffian = Fn.new { |a, pfaffian|
    if (a.count % 2 != 0) {
        System.print("Matrix size must be even for %(pfaffian ? "P" : "H")faffian.")
        return null
    }
    if (!isAntisymmetric.call(a)) {
        System.print("The %(pfaffian ? "P" : "H")faffian does not support non-antisymmetric matrices yet.")
        return null
    }
    var n = (a.count / 2).floor
    var normalization = 1 / (2.pow(n) * Int.factorial(n))
    var sum = 0
    var perms = spermutations.call(2 * n - 1)
    for (ss in perms) {
        var sigma = ss[0]
        var sign  = pfaffian ? ss[1] : 1
        var prod = 1
        for (i in 0...n) {
            prod = prod * a[sigma[2 * i]][sigma[2 * i + 1]]
        }
        sum = sum + sign * prod
    }
    return sum * normalization
}

var matrices = [
    // Tiny matrix (2 x 2).
    [ [0, 1], [-1, 0] ],

    // Small matrix (4 x 4).
    [
        [ 0,  1, -1,  2],
        [-1,  0,  3, -4],
        [ 1, -3,  0,  5],
        [-2,  4, -5,  0]
    ],

    // Symmetric matrix (6 x 6).
    [
        [1,  2,  3,  4,  5,  6],
        [2,  7,  8,  9, 10, 11],
        [3,  8, 12, 13, 14, 15],
        [4,  9, 13, 16, 17, 18],
        [5, 10, 14, 17, 19, 20],
        [6, 11, 15, 18, 20, 21]
    ],

    // Larger matrix (10 x 10).
    [
        [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9],
        [-1,  0,  8,  7,  6,  5,  4,  3,  2,  1],
        [-2, -8,  0,  1,  2,  3,  4,  5,  6,  7],
        [-3, -7, -1,  0,  6,  5,  4,  3,  2,  1],
        [-4, -6, -2, -6,  0,  1,  2,  3,  4,  5],
        [-5, -5, -3, -5, -1,  0,  4,  3,  2,  1],
        [-6, -4, -4, -4, -2, -4,  0,  1,  2,  3],
        [-7, -3, -5, -3, -3, -3, -1,  0,  2,  1],
        [-8, -2, -6, -2, -4, -2, -2, -2,  0,  1],
        [-9, -1, -7, -1, -5, -1, -3, -1, -1,  0]
    ]
]

for (m in matrices) {
    Fmt.mprint(m, 3, 0)
    System.print()
    var res
    if (res = faffian.call(m, true))  Fmt.print("Pfaffian: $,g", res)
    if (res = faffian.call(m, false)) Fmt.print("Hfaffian: $,g", res)
    System.print()
}
