import "./matrix" for Matrix
import "./fmt" for Fmt

var walshMatrix = Fn.new { |n|
    var walsh = Matrix.new(n, n, 0)
    walsh[0, 0] = 1
    var k = 1
    while (k < n) {
        for (i in 0...k) {
            for (j in 0...k) {
                walsh[i+k, j]   =  walsh[i, j]
                walsh[i, j+k]   =  walsh[i, j]
                walsh[i+k, j+k] = -walsh[i, j]
            }
        }
        k = k + k
    }
    return walsh
}

var signChanges = Fn.new { |row|
    var n = row.count
    var sc = 0
    for (i in 1...n) {
        if (row[i-1] == -row[i]) sc = sc + 1
    }
    return sc
}

var walshCache = {} // to avoid calculating the Walsh matrix twice

for (order in [2, 4, 5]) {
    var n = 1 << order
    Fmt.print("Walsh matrix - order $d ($d x $d), natural order:", order, n, n)
    var w = walshMatrix.call(n)
    walshCache[order] = w
    Fmt.mprint(w, 2, 0, "|", true)
    System.print()
}

for (order in [2, 4, 5]) {
    var n = 1 << order
    Fmt.print("Walsh matrix - order $d ($d x $d), sequency order:", order, n, n)
    var rows = walshCache[order].toList
    rows.sort { |r1, r2| signChanges.call(r1) < signChanges.call(r2) }
    Fmt.mprint(rows, 2, 0, "|", true)
    System.print()
}
