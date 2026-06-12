import "random" for Random

var rand = Random.new()

var sattolo = Fn.new { |items|
    var count = items.count
    if (count < 2) return
    for (i in count-1..1) {
        var j = rand.int(i)
        var t = items[i]
        items[i] = items[j]
        items[j] = t
    }
}

var tests = [[], [10], [10, 20], [10, 20, 30], [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22],
    ["a", "b", "c", "d", "e"], ["fgh", "ijk", "lmn", "opq", "rst", "uvw", "xyz"] ]
for (test in tests) {
    System.print("Original: %(test)")
    sattolo.call(test)
    System.print("Sattolo : %(test)\n")
}
