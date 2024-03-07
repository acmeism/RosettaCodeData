import "./fmt" for Fmt

var areSame = Fn.new { |a, b|
    for (i in 0...a.count) if (a[i] != b[i]) return false
    return true
}

var perfectShuffle = Fn.new { |a|
    var n = a.count
    var b = List.filled(n, 0)
    var hSize = (n/2).floor
    for (i in 0...hSize) b[i * 2] = a[i]
    var j = 1
    for (i in hSize...n) {
        b[j] = a[i]
        j = j + 2
    }
    return b
}

var countShuffles = Fn.new { |a|
    var n = a.count
    if (n < 2 || n % 2 == 1) Fiber.abort("Array must be even-sized and non-empty.")
    var b = a
    var count = 0
    while (true) {
        var c = perfectShuffle.call(b)
        count = count + 1
        if (areSame.call(a, c)) return count
        b = c
    }
}

System.print("Deck size  Num shuffles")
System.print("---------  ------------")
var sizes = [8, 24, 52, 100, 1020, 1024, 10000]
for (size in sizes) {
    var a = List.filled(size, 0)
    for (i in 1...size) a[i] = i
    var count = countShuffles.call(a)
    Fmt.print("$-9d     $d", size, count)
}
