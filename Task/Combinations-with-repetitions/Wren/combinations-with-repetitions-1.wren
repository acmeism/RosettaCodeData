var combrep // recursive
combrep = Fn.new { |n, lst|
    if (n == 0 ) return [[]]
    if (lst.count == 0) return []
    var r = combrep.call(n, lst[1..-1])
    for (x in combrep.call(n-1, lst)) {
        var y = x.toList
        y.add(lst[0])
        r.add(y)
    }
    return r
}

System.print(combrep.call(2, ["iced", "jam", "plain"]))
System.print(combrep.call(3, (1..10).toList).count)
