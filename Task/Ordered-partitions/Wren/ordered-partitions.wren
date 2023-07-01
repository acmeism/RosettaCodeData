import "os" for Process

var genPart // recursive so predeclare
genPart = Fn.new { |n, res, pos|
    if (pos == res.count) {
        var x = List.filled(n.count, null)
        for (i in 0...x.count) x[i] = []
        var i = 0
        for (c in res) {
            x[c].add(i+1)
            i = i + 1
        }
        System.print(x)
        return
    }
    for (i in 0...n.count) {
        if (n[i] != 0) {
            n[i] = n[i] - 1
            res[pos] = i
            genPart.call(n, res, pos+1)
            n[i] = n[i] + 1
        }
    }
}

var orderedPart = Fn.new { |nParts|
    System.print("Ordered %(nParts)")
    var sum = 0
    for (c in nParts) sum = sum + c
    genPart.call(nParts, List.filled(sum, 0), 0)
}

var args = Process.arguments
if (args.count == 0) {
    orderedPart.call([2, 0, 2])
    return
}
var n = List.filled(args.count, 0)
var i = 0
for (a in args) {
    n[i] = Num.fromString(a)
    if (n[i] < 0) {
        System.print("negative partition size not meaningful")
        return
    }
    i = i + 1
}
orderedPart.call(n)
