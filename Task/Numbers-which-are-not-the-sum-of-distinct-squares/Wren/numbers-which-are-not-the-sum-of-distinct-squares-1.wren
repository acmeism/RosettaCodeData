var squares = (1..18).map { |i| i * i }.toList
var combs = []
var results = []

// generate combinations of the numbers 0 to n-1 taken m at a time
var combGen = Fn.new { |n, m|
    var s = List.filled(m, 0)
    var last = m - 1
    var rc // recursive closure
    rc = Fn.new { |i, next|
        var j = next
        while (j < n) {
            s[i] = j
            if (i == last) {
                combs.add(s.toList)
            } else {
                rc.call(i+1, j+1)
            }
            j = j + 1
        }
    }
    rc.call(0, 0)
}

for (n in 1..324) {
    var all = true
    for (m in 1..18) {
        combGen.call(18, m)
        for (comb in combs) {
            var tot = (0...m).reduce(0) { |acc, i| acc + squares[comb[i]] }
            if (tot == n) {
                all = false
                break
            }
        }
        if (!all) break
        combs.clear()
    }
    if (all) results.add(n)
}

System.print("Numbers which are not the sum of distinct squares:")
System.print(results)
