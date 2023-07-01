import "/sort" for Sort
import "/fmt" for Fmt

class Term {
    construct new(coeff, ix1, ix2) {
        _coeff = coeff
        _ix1 = ix1
        _ix2 = ix2
    }
    coeff { _coeff }
    ix1 { _ix1 }
    ix2 { _ix2 }
}

var maxDigits = 15

var toInt = Fn.new { |digits, reverse|
    var sum = 0
    if (!reverse) {
        for (i in 0...digits.count) sum = sum*10 + digits[i]
    } else {
        for (i in digits.count-1..0) sum = sum*10 + digits[i]
    }
    return sum
}

var isSquare = Fn.new { |n|
    var root = n.sqrt.floor
    return root*root == n
}

var seq = Fn.new { |from, to, step|
    var res = []
    var i = from
    while (i <= to) {
        res.add(i)
        i = i + step
    }
    return res
}

var start = System.clock
var pow = 1
System.print("Aggregate timings to process all numbers up to:")

// terms of (n-r) expression for number of digits from 2 to maxDigits
var allTerms = List.filled(maxDigits-1, null)
for (r in 2..maxDigits) {
    var terms = []
    pow = pow * 10
    var pow1 = pow
    var pow2 = 1
    var i1 = 0
    var i2 = r - 1
    while (i1 < i2) {
        terms.add(Term.new(pow1-pow2, i1, i2))
        pow1 = (pow1/10).floor
        pow2 = pow2 * 10
        i1 = i1 + 1
        i2 = i2 - 1
    }
    allTerms[r-2] = terms
}

//  map of first minus last digits for 'n' to pairs giving this value
var fml = {
    0: [[2, 2], [8, 8]],
    1: [[6, 5], [8, 7]],
    4: [[4, 0]],
    6: [[6, 0], [8, 2]]
}

// map of other digit differences for 'n' to pairs giving this value
var dmd = {}
for (i in 0...100) {
    var a = [(i/10).floor, i%10]
    var d = a[0] - a[1]
    if (dmd[d]) {
        dmd[d].add(a)
    } else {
        dmd[d] = [a]
    }
}
var fl = [0, 1, 4, 6]
var dl = seq.call(-9, 9, 1)  // all differences
var zl = [0]                 // zero differences only
var el = seq.call(-8, 8, 2)  // even differences only
var ol = seq.call(-9, 9, 2)  // odd differences only
var il = seq.call(0, 9, 1)
var rares = []
var lists = List.filled(4, null)
for (i in 0..3) lists[i] = [[fl[i]]]
var digits = []
var count = 0

// Recursive closure to generate (n+r) candidates from (n-r) candidates
// and hence find Rare numbers with a given number of digits.
var fnpr
fnpr = Fn.new { |cand, di, dis, indices, nmr, nd, level|
    if (level == dis.count) {
        digits[indices[0][0]] = fml[cand[0]][di[0]][0]
        digits[indices[0][1]] = fml[cand[0]][di[0]][1]
        var le = di.count
        if (nd%2 == 1) {
            le = le - 1
            digits[(nd/2).floor] = di[le]
        }
        var i = 0
        for (d in di[1...le]) {
            digits[indices[i+1][0]] = dmd[cand[i+1]][d][0]
            digits[indices[i+1][1]] = dmd[cand[i+1]][d][1]
            i = i + 1
        }
        var r = toInt.call(digits, true)
        var npr = nmr + 2*r
        if (!isSquare.call(npr)) return
        count = count + 1
        Fmt.write("     R/N $2d:", count)
        var ms = ((System.clock - start)*1000).round
        Fmt.write("  $,7d ms", ms)
        var n = toInt.call(digits, false)
        Fmt.print("  ($,d)", n)
        rares.add(n)
    } else {
        for (num in dis[level]) {
            di[level] = num
            fnpr.call(cand, di, dis, indices, nmr, nd, level+1)
        }
    }
}

// Recursive closure to generate (n-r) candidates with a given number of digits.
var fnmr
fnmr = Fn.new { |cand, list, indices, nd, level|
    if (level == list.count) {
        var nmr = 0
        var nmr2 = 0
        var i = 0
        for (t in allTerms[nd-2]) {
            if (cand[i] >= 0) {
                nmr = nmr + t.coeff*cand[i]
            } else {
                nmr2 = nmr2 - t.coeff*cand[i]
                if (nmr >= nmr2) {
                    nmr = nmr - nmr2
                    nmr2 = 0
                } else {
                    nmr2 = nmr2 - nmr
                    nmr = 0
                }
            }
            i = i + 1
        }
        if (nmr2 >= nmr) return
        nmr = nmr - nmr2
        if (!isSquare.call(nmr)) return
        var dis = []
        dis.add(seq.call(0, fml[cand[0]].count-1, 1))
        for (i in 1...cand.count) {
            dis.add(seq.call(0, dmd[cand[i]].count-1, 1))
        }
        if (nd%2 == 1) dis.add(il)
        var di = List.filled(dis.count, 0)
        fnpr.call(cand, di, dis, indices, nmr, nd, 0)
    } else {
        for (num in list[level]) {
            cand[level] = num
            fnmr.call(cand, list, indices, nd, level+1)
        }
    }
}

for (nd in 2..maxDigits) {
    digits = List.filled(nd, 0)
    if (nd == 4) {
        lists[0].add(zl)
        lists[1].add(ol)
        lists[2].add(el)
        lists[3].add(ol)
    } else if(allTerms[nd-2].count > lists[0].count) {
        for (i in 0..3) lists[i].add(dl)
    }
    var indices = []
    for (t in allTerms[nd-2]) indices.add([t.ix1, t.ix2])
    for (list in lists) {
        var cand = List.filled(list.count, 0)
        fnmr.call(cand, list, indices, nd, 0)
    }
    var ms = ((System.clock - start)*1000).round
    Fmt.print("  $2s digits:  $,7d ms", nd, ms)
}

Sort.quick(rares)
Fmt.print("\nThe rare numbers with up to $d digits are:\n", maxDigits)
var i = 0
for (rare in rares) {
    Fmt.print("  $2d:  $,21d", i+1, rare)
    i = i + 1
}
