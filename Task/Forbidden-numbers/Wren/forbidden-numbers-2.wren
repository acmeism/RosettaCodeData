import "./fmt" for Fmt

var isForbidden = Fn.new { |n|
    var m = n
    var v = 0
    while (m > 1 && m % 4 == 0) {
        m = (m/4).floor
        v = v + 1
    }
    return (n/4.pow(v)).floor % 8 == 7
}

var f400 = (1..400).where { |i| isForbidden.call(i) }
System.print("The first 50 forbidden numbers are:")
Fmt.tprint("$3d", f400.take(50), 10)
System.print()
for (limit in [500, 5000, 50000, 500000, 5000000]) {
     var count = (1..limit).count { |i| isForbidden.call(i) }
     Fmt.print("Forbidden number count <= $,9d: $,7d", limit, count)
}
