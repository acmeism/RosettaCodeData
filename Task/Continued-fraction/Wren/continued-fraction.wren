var calc = Fn.new { |f, n|
    var t = 0
    for (i in n..1) {
        var p = f.call(i)
        t = p[1] / (p[0] + t)
    }
    return f.call(0)[0] + t
}

var pList = [
    ["sqrt(2)", Fn.new { |n| [(n > 0) ? 2 : 1, 1] }],
    ["e      ", Fn.new { |n| [(n > 0) ? n : 2, (n > 1) ? n - 1 : 1] }],
    ["pi     ", Fn.new { |n| [(n > 0) ? 6 : 3, (2*n - 1) * (2*n - 1)] }]
]
for (p in pList) System.print("%(p[0]) = %(calc.call(p[1], 200))")
