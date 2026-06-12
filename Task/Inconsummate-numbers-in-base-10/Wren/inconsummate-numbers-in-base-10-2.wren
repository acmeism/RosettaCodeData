import "./math" for Int, Nums
import "./fmt" for Fmt

var generateInconsummate = Fiber.new { |maxWanted|
    var minDigitSums = (2..14).map { |i| [10.pow(i), ((10.pow(i-2) * 11 - 1) / (9 * i - 17)).floor] }
    var limit = Nums.min(minDigitSums.where { |p| p[1] > maxWanted }.map { |p| p[0] })
    var arr = List.filled(limit, 0)
    arr[0] = 1
    for (dividend in 1...limit) {
        var ds = Int.digitSum(dividend)
        var quo = (dividend/ds).floor
        var rem = dividend % ds
        if (rem == 0 && quo < limit) arr[quo] = 1
    }
    for (j in 0...arr.count) {
        if (arr[j] == 0) Fiber.yield(j)
    }
}

var incons = List.filled(50, 0)
System.print("First 50 inconsummate numbers in base 10:")
for (i in 1..100000) {
    var j = generateInconsummate.call(100000)
    if (i <= 50) {
        incons[i-1] = j
        if (i == 50) Fmt.tprint("$3d", incons, 10)
    } else if (i == 1000) {
        Fmt.print("\nOne thousandth $,d", j)
    } else if (i == 10000) {
        Fmt.print("Ten thousandth $,d", j)
    } else if (i == 100000) {
        Fmt.print("100 thousandth $,d", j)
    }
}
