var beadSort = Fn.new { |a|
    var res = []
    var max = a.reduce { |acc, i| (i > acc) ? i : acc }
    var trans = [0] * max
    for (i in a) {
        for (n in 0...i) trans[n] = trans[n] + 1
    }
    for (i in a) {
        res.add(trans.count { |n| n > 0 })
        for (n in 0...trans.count) trans[n] = trans[n] - 1
    }
    return res[-1..0] // return in ascending order
}

var as = [ [4, 65, 2, 31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in as) {
    System.print("Before: %(a)")
    a = beadSort.call(a)
    System.print("After : %(a)")
    System.print()
}
