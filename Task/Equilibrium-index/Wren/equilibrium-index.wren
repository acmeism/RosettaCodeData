import "/fmt" for Fmt

var equilibrium = Fn.new { |a|
    var len = a.count
    var equi = []
    if (len == 0) return equi // sequence has no indices at all
    var rsum = a.reduce { |acc, x| acc + x }
    var lsum = 0
    for (i in 0...len) {
        rsum = rsum - a[i]
        if (rsum == lsum) equi.add(i)
        lsum = lsum + a[i]
    }
    return equi
}

var tests = [
    [-7, 1, 5, 2, -4, 3, 0],
    [2, 4, 6],
    [2, 9, 2],
    [1, -1, 1, -1, 1, -1, 1],
    [1],
    []
]

System.print("The equilibrium indices for the following sequences are:\n")
for (test in tests) {
    System.print("%(Fmt.s(24, test)) -> %(equilibrium.call(test))")
}
