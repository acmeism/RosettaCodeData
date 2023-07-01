import "/sort" for Sort

var fivenum = Fn.new { |a|
    Sort.quick(a)
    var n5 = List.filled(5, 0)
    var n = a.count
    var n4 = ((n + 3)/2).floor / 2
    var d = [1, n4, (n + 1)/2, n + 1 - n4, n]
    var e = 0
    for (de in d) {
        var floor = (de - 1).floor
        var ceil  = (de - 1).ceil
        n5[e] = 0.5 * (a[floor] + a[ceil])
        e = e + 1
    }
    return n5
}

var x1 = [36, 40, 7, 39, 41, 15]
var x2 = [15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43]
var x3 = [
    0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,
    0.73438555, -0.03035726,  1.46675970, -0.74621349, -0.72588772,
    0.63905160,  0.61501527, -0.98983780, -1.00447874, -0.62759469,
    0.66206163,  1.04312009, -0.10305385,  0.75775634,  0.32566578
]
for (x in [x1, x2, x3]) System.print(fivenum.call(x))
