var twosum = Fn.new { |a, n|
    var c = a.count
    if (c < 2) return []
    for (i in 0...c-1) {
        for (j in i+1...c) {
            var s = a[i] + a[j]
            if (s == n) return [i, j]
            if (s > n) break
        }
    }
    return []
}

var a = [0, 2, 11, 19, 90]
System.print("Numbers: %(a)\n")
for (n in [21, 25, 90]) {
    var pair = twosum.call(a, n)
    if (pair.count == 2) {
        System.print("Indices: %(pair) sum to %(n) (%(a[pair[0]]) + %(a[pair[1]]) = %(n))")
    } else {
        System.print("No pairs of the above numbers sum to %(n).")
    }
    System.print()
}
