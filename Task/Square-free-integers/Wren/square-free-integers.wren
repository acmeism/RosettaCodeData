import "./fmt" for Fmt

var isSquareFree = Fn.new { |n|
    var i = 2
    while (i * i <= n) {
        if (n%(i*i) == 0) return false
        i = (i > 2) ? i + 2 : i + 1
    }
    return true
}

var ranges = [ [1..145, 3, 20], [1e12..1e12+145, 12, 5] ]
for (r in ranges) {
    System.print("The square-free integers between %(r[0].min) and %(r[0].max) inclusive are:")
    var count = 0
    for (i in r[0]) {
        if (isSquareFree.call(i)) {
            count = count + 1
            System.write("%(Fmt.d(r[1], i)) ")
            if (count %r[2] == 0) System.print()
        }
    }
    System.print("\n")
}
System.print("Counts of square-free integers:")
var count = 0
var lims = [0, 100, 1000, 1e4, 1e5, 1e6]
for (i in 1...lims.count) {
    System.write("  from 1 to (inclusive) %(Fmt.d(-7, lims[i])) = ")
    for (j in lims[i-1]+1..lims[i]) {
        if (isSquareFree.call(j)) count = count + 1
    }
    System.print(count)
}
