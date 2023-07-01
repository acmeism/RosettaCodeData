import "io" for Stdin, Stdout
import "/pattern" for Pattern

var p = Pattern.new("[,+1/s|+1/s,|+1/s|,]")

var spark = Fn.new { |s0|
    var ss = p.splitAll(s0)
    var n = ss.count
    var vs = List.filled(n, 0)
    var min = 1/0
    var max = -min
    var i = 0
    for (s in ss) {
        var v = Num.fromString(s)
        if (v.isNan || v.isInfinity) Fiber.abort("Infinities and NaN not supported.")
        if (v < min) min = v
        if (v > max) max = v
        vs[i] = v
        i = i + 1
    }
    var sp
    if (min == max) {
        sp = "▄" * n
    } else {
        var rs = List.filled(n, null)
        var f = 8 / (max - min)
        var j = 0
        for (v in vs) {
            var i = (f * (v - min)).floor
            if (i > 7) i = 7
            rs[j] = String.fromCodePoint(0x2581 + i)
            j = j + 1
        }
        sp = rs.join()
    }
    return [sp, n, min, max]
}

while (true) {
    System.print("Numbers please separated by spaces/commas or just press return to quit:")
    Stdout.flush()
    var numbers = Stdin.readLine().trim()
    if (numbers == "") break
    var res = spark.call(numbers)
    var s = res[0]
    var n = res[1]
    var min = res[2]
    var max = res[3]
    if (n == 1) {
        System.print("1 value = %(min)")
    } else {
        System.print("%(n) values.  Min: %(min) Max: %(max)")
    }
    System.print(s)
    System.print()
}
