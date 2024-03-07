import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()
var RAND_MAX = 32767

var list = []
var w = 0
var ww = 0

var ALPHA = "+.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
var ALEN  = ALPHA.count - 3

var makeList = Fn.new { |p|
    var thresh = (p * RAND_MAX).truncate
    ww = w * w
    var i = ww
    list = List.filled(i, 0)
    while (i != 0) {
        i = i - 1
        var r = rand.int(RAND_MAX+1)
        if (r < thresh) list[i] = -1
    }
}

var showCluster = Fn.new {
    var k = 0
    for (i in 0...w) {
        for (j in 0...w) {
            var s = list[k]
            k = k + 1
            var c = (s < ALEN) ? ALPHA[1 + s] : "?"
            System.write(" %(c)")
        }
        System.print()
    }
}

var recur // recursive
recur = Fn.new { |x, v|
    if (x >= 0 && x < ww && list[x] == -1) {
        list[x] = v
        recur.call(x - w, v)
        recur.call(x - 1, v)
        recur.call(x + 1, v)
        recur.call(x + w, v)
    }
}

var countClusters = Fn.new {
    var cls = 0
    for (i in 0...ww) {
        if (list[i] == -1) {
            cls = cls + 1
            recur.call(i, cls)
        }
    }
    return cls
}

var tests = Fn.new { |n, p|
    var k = 0
    for (i in 0...n) {
        makeList.call(p)
        k = k + countClusters.call() / ww
    }
    return k / n
}

w = 15
makeList.call(0.5)
var cls = countClusters.call()
System.print("width = 15, p = 0.5, %(cls) clusters:")
showCluster.call()

System.print("\np = 0.5, iter = 5:")
w = 1 << 2
while (w <= (1 << 13)) {
    var t = tests.call(5, 0.5)
    Fmt.print("$5d $9.6f", w, t)
    w = w << 1
}
