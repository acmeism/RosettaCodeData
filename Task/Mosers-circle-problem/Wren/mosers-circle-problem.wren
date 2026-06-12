import "./math" for Math

var moser = Fn.new { |n| Math.evalPoly([1, -6, 23, -18, 24], n) / 24 }

var binomial = Fn.new { |n, k|
    if (k > n) return 0
    if (k == 0) return 1
    var res = 1
    for (i in 1..k) res = res * (n - i + 1) / i
    return res
}

var binomialTransform = Fn.new { |seq, m|
    var res = []
    for (n in 0...m) {
        var sum = 0
        for (k in 0..n) sum = sum + binomial.call(n, k) * seq[k]
        res.add(sum)
    }
    return res
}

var pascalTriangle = Fn.new { |m|
    var tri = List.filled(m, 0)
    var a = List.filled(m, null)
    for (i in 0...m) a[i] = List.filled(m, 0)
    for (r in 0...m) {
        a[r][0] = 1
        if (r > 0) for (c in 1..r) a[r][c] = a[r - 1][c - 1] + a[r - 1][c]
    }
    for (r in 0...m) {
        // only need to sum first 5 columns
        for (c in 0..4) {
            tri[r] = tri[r] + a[r][c]
        }
    }
    return tri
}

var bernoulliTriangle = Fn.new { |m|
    var res = []
    var prevRow = []
    for (n in 0...m) {
        var row = []
        for (k in 0..n) {
            if (k == 0) {
                row.add(1)
            } else if (k < n) {
                row.add(prevRow[k] + prevRow[k - 1])
            } else {
                row.add(1 << n)
            }
        }
        res.add(row.count < 5 ? row[-1] : row[4])
        prevRow = row
    }
    return res
}

var max = 20

System.print("The first %(max) values of Moser's circle problem calculated in 5 different ways:")

System.print("\nDirect calculation of a 4th order equation:")
for (n in 1..max) System.write("%(moser.call(n)) ")
System.print()

System.print("\nUsing binomial sums:")
for (n in 1..max) {
    var bs = binomial.call(n, 4) + binomial.call(n, 2) + 1
    System.write("%(bs) ")
}
System.print()

System.print("\nUsing a binomial transform:")
var seq = [1] * 5 + [0] * (max - 5)
System.print(binomialTransform.call(seq, max).map { |i| i.toString }.join(" "))

System.print("\nPartial sums of Pascal's triangle:")
System.print(pascalTriangle.call(max).map { |i| i.toString }.join(" "))

System.print("\nFifth column of Bernoulli's triangle:")
System.print(bernoulliTriangle.call(max).map { |i| i.toString }.join(" "))
