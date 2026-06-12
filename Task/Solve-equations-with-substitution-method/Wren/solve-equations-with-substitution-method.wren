var solve = Fn.new { |e1, e2|
    e2 = e2.toList
    for (i in 1..2) e2[i] = e2[i] * e1[0] / e2[0]
    var y = (e2[2] - e1[2]) / (e2[1] - e1[1])
    var x = (e1[2] - e1[1] * y) / e1[0]
    return [x, y]
}

var e1 = [3, 1, -1]
var e2 = [2, -3, -19]
var sol = solve.call(e1, e2)
System.print("x = %(sol[0]), y = %(sol[1])")
