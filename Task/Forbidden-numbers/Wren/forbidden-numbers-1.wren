import "./fmt" for Fmt

var forbidden = Fn.new { |limit, countOnly|
    var sieve = List.filled(limit+1, false)
    var ones
    var twos
    var threes
    var i = 0
    while((ones = i*i) <= limit) {
        sieve[ones] = true
        var j = i
        while ((twos = ones + j*j) <= limit) {
            sieve[twos] = true
            var k = j
            while ((threes = twos + k*k) <= limit) {
                sieve[threes] = true
                k = k + 1
            }
            j = j + 1
        }
        i = i + 1
    }
    if (countOnly) return sieve.count { |b| !b }
    var forbidden = []
    for (i in 1..limit) {
        if (!sieve[i]) forbidden.add(i)
    }
    return forbidden
}

System.print("The first 50 forbidden numbers are:")
Fmt.tprint("$3d", forbidden.call(400, false).take(50), 10)
System.print()
for (limit in [500, 5000, 50000, 500000, 5000000]) {
     var count = forbidden.call(limit, true)
     Fmt.print("Forbidden number count <= $,9d: $,7d", limit, count)
}
