import "./seq" for Lst

var maxBase = 10
var usedDigits = List.filled(maxBase, 0)
var powerDgt = List.filled(maxBase, null)
var numbers = []

var initPowerDgt = Fn.new {
    for (i in 0...maxBase) powerDgt[i] = List.filled(maxBase, 0)
    for (i in 1...maxBase) powerDgt[0][i] = 1
    for (j in 1...maxBase) {
        for (i in 0...maxBase) powerDgt[j][i] = powerDgt[j-1][i] * i
    }
}

var calcNum = Fn.new { |depth, used|
    if (depth < 3) return 0
    var result = 0
    for (i in 1...maxBase) {
        if (used[i] > 0) result = result + used[i] * powerDgt[depth][i]
    }
    if (result == 0) return 0
    var n = result
    while (true) {
        var r = (n/maxBase).floor
        used[n - r*maxBase] = used[n - r*maxBase] - 1
        n = r
        depth = depth - 1
        if (r == 0) break
    }
    if (depth != 0) return 0
    var i = 1
    while (i < maxBase && used[i] == 0) i = i + 1
    if (i >= maxBase) numbers.add(result)
    return 0
}

var nextDigit // recursive function
nextDigit = Fn.new { |dgt, depth|
    if (depth < maxBase-1) {
        for (i in dgt...maxBase) {
            usedDigits[dgt] = usedDigits[dgt] + 1
            nextDigit.call(i, depth + 1)
            usedDigits[dgt] = usedDigits[dgt] - 1
        }
    }
    if (dgt == 0) dgt = 1
    for (i in dgt...maxBase) {
        usedDigits[i] = usedDigits[i] + 1
        calcNum.call(depth, usedDigits.toList)
        usedDigits[i] = usedDigits[i] - 1
    }
}

initPowerDgt.call()
nextDigit.call(0, 0)
numbers = Lst.distinct(numbers)
numbers.sort()
System.print("Own digits power sums for N = 3 to 9 inclusive:")
System.print(numbers.map { |n| n.toString }.join("\n"))
