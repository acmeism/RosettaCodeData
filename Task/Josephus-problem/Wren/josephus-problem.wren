var josephus = Fn.new { |n, k, m|
    if (k <= 0 || m <= 0 || n <= k || n <= m) Fiber.abort("One or more parameters are invalid.")
    var killed = []
    var survived = List.filled(n, 0)
    for (i in 0...n) survived[i] = i
    var start = k - 1
    while (true) {
        var end = survived.count - 1
        var i = start
        var deleted = 0
        while (i <= end) {
            killed.add(survived.removeAt(i-deleted))
            if (survived.count == m) return [survived, killed]
            deleted = deleted + 1
            i = i + k
        }
        start = i - end - 1
    }
    return [survived, killed]
}

var triples = [ [5, 2, 1], [41, 3, 1], [41, 3, 3] ]
for (triple in triples) {
    var n = triple[0]
    var k = triple[1]
    var m = triple[2]
    System.print("Prisoners = %(n), Step = %(k), Survivors = %(m)")
    var sk = josephus.call(n, k, m)
    System.print("Survived   : %(sk[0])")
    System.print("Kill order : %(sk[1])")
    System.print()
}
