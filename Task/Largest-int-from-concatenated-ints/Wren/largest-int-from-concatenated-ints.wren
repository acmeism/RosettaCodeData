import "./sort" for Sort

var cmp = Fn.new { |x, y|
    var xy = Num.fromString(x.toString + y.toString)
    var yx = Num.fromString(y.toString + x.toString)
    return (xy - yx).sign
}

var findLargestSequence = Fn.new { |a|
    var b = Sort.merge(a, cmp)
    return b[-1..0].join()
}

var arrays = [
    [1, 34, 3, 98, 9, 76, 45, 4],
    [54, 546, 548, 60]
]
for (a in arrays) {
    System.print("%(a) -> %(findLargestSequence.call(a))")
}
