var Combrep = Fn.new { |n, lst|
    if (n == 0 ) return [[]]
    if (lst.count == 0) return []
    var r = Combrep.call(n, lst[1..-1])
    for (x in Combrep.call(n-1, lst)) {
        var y = x.toList
        y.add(lst[0])
        r.add(y)
    }
    return r
}

System.print(Combrep.call(2, ["iced", "jam", "plain"]))
System.print(Combrep.call(3, (1..10).toList).count)
