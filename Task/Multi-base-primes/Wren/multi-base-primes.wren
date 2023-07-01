import "/math" for Int, Nums

var maxDepth = 5
var maxBase = 36
var c = Int.primeSieve(maxBase.pow(maxDepth), false)
var digits = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
var maxStrings = []
var mostBases = -1

var process = Fn.new { |indices|
    var minBase = 2.max(Nums.max(indices) + 1)
    if (maxBase - minBase + 1 < mostBases) return  // can't affect results so return
    var bases = []
    for (b in minBase..maxBase) {
        var n = 0
        for (i in indices) n = n * b + i
        if (!c[n]) bases.add(b)
    }
    var count = bases.count
    if (count > mostBases) {
        mostBases = count
        maxStrings = [[indices.toList, bases]]
    } else if (count == mostBases) {
        maxStrings.add([indices.toList, bases])
    }
}

var printResults = Fn.new {
    System.print("%(maxStrings[0][1].count)")
    for (m in maxStrings) {
        var s = m[0].reduce("") { |acc, i| acc + digits[i] }
        System.print("%(s) -> %(m[1])")
    }
}

var nestedFor // recursive
nestedFor = Fn.new { |indices, length, level|
    if (level == indices.count) {
        process.call(indices)
    } else {
        indices[level] = (level == 0) ? 1 : 0
        while (indices[level] < length) {
             nestedFor.call(indices, length, level + 1)
             indices[level] = indices[level] + 1
        }
    }
}

for (depth in 1..maxDepth) {
    System.write("%(depth) character strings which are prime in most bases: ")
    maxStrings = []
    mostBases = -1
    var indices = List.filled(depth, 0)
    nestedFor.call(indices, maxBase, 0)
    printResults.call()
    System.print()
}
