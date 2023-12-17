import "./big" for BigInt
import "./fmt" for Fmt
import "./iterate" for Stepped

var perm = Fn.new { |n, k|
    if (n <= 0 || k < 0) Fiber.abort("Invalid argument(s).")
    if (k == 0) return BigInt.one
    return (n-k+1..n).reduce(BigInt.one) { |acc, i| acc * BigInt.new(i) }
}

var comb = Fn.new { |n, k|
    if (n <= 0 || k < 0) Fiber.abort("Invalid argument(s).")
    var fact = BigInt.one
    if (k > 1) fact = (2..k).reduce(BigInt.one) { |acc, i| acc * BigInt.new(i) }
    return perm.call(n, k) / fact
}

System.print("A sample of permutations from 1 to 12:")
for (n in 1..12) Fmt.print("$2d P $-2d = $i", n, (n/3).floor, perm.call(n, (n/3).floor))

System.print("\nA sample of combinations from 10 to 60:")
for (n in Stepped.new(10..60, 10)) {
    Fmt.print("$2d C $-2d = $i", n, (n/3).floor, comb.call(n, (n/3).floor))
}

System.print("\nA sample of permutations from 5 to 15000:")
var na = [5, 50, 500, 1000, 5000, 15000]
for (n in na) {
    var k = (n/3).floor
    var s = perm.call(n, k).toString
    var l = s.count
    var e = (l <= 40) ? "" : "... (%(l - 40) more digits)"
    Fmt.print("$5d P $-4d = $s$s", n, k, s.take(40).join(), e)
}

System.print("\nA sample of combinations from 100 to 1000:")
for (n in Stepped.new(100..1000, 100)) {
    var k = (n/3).floor
    var s = comb.call(n, k).toString
    var l = s.count
    var e = (l <= 40) ? "" : "... (%(l - 40) more digits)"
    Fmt.print("$4d C $-3d = $s$s", n, k, s.take(40).join(), e)
}
