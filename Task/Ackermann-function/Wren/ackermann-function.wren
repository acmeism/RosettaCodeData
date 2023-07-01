// To use recursion definition and declaration must be on separate lines
var Ackermann
Ackermann = Fn.new {|m, n|
    if (m == 0) return n + 1
    if (n == 0) return Ackermann.call(m - 1, 1)
    return Ackermann.call(m - 1, Ackermann.call(m, n - 1))
}

var pairs = [ [1, 3], [2, 3], [3, 3], [1, 5], [2, 5], [3, 5] ]
for (pair in pairs) {
    var p1 = pair[0]
    var p2 = pair[1]
    System.print("A[%(p1), %(p2)] = %(Ackermann.call(p1, p2))")
}
