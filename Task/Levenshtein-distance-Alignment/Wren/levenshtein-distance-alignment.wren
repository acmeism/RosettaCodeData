import "/str" for Str

var levenshteinAlign = Fn.new { |a, b|
    a = Str.lower(a)
    b = Str.lower(b)
    var costs = List.filled(a.count+1, null)
    for (i in 0..a.count) costs[i] = List.filled(b.count+1, 0)
    for (j in 0..b.count) costs[0][j] = j
    for (i in 1..a.count) {
        costs[i][0] = i
        for (j in 1..b.count) {
            var temp = costs[i - 1][j - 1] + ((a[i - 1] == b[j - 1]) ? 0 : 1)
            costs[i][j] = temp.min(1 + costs[i - 1][j].min(costs[i][j - 1]))
        }
    }
    // walk back through matrix to figure out path
    var aPathRev = ""
    var bPathRev = ""
    var i = a.count
    var j = b.count
    while (i != 0 && j != 0) {
        var temp = costs[i - 1][j - 1] + ((a[i - 1] == b[j - 1]) ? 0 : 1)
        var cij = costs[i][j]
        if (cij == temp) {
            i = i - 1
            aPathRev = aPathRev + a[i]
            j = j - 1
            bPathRev = bPathRev + b[j]
        } else if (cij == 1 + costs[i-1][j]) {
            i = i - 1
            aPathRev = aPathRev + a[i]
            bPathRev = bPathRev + "-"
        } else if (cij == 1 + costs[i][j-1]) {
            aPathRev = aPathRev + "-"
            j = j - 1
            bPathRev = bPathRev+ b[j]
        }
    }
    return [aPathRev[-1..0], bPathRev[-1..0]]
}

var result = levenshteinAlign.call("place", "palace")
System.print(result[0])
System.print(result[1])
System.print()
result = levenshteinAlign.call("rosettacode","raisethysword")
System.print(result[0])
System.print(result[1])
