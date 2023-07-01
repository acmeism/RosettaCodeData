import "./sort" for SortedList
import "./fmt" for Fmt

var extend = Fn.new { |W, length, n|
    var w = 1
    var x = length + 1
    while (x <= n) {
        W.add(x)
        var ix = W.indexOf(w)
        w = W[ix+1]
        x = length + w
    }
}

var deleteMultiples = Fn.new { |W, length, p|
    var w = p
    while (p * w <= length) {
        var ix = W.indexOf(w)
        w = W[ix+1]
    }
    while (w > 1) {
        var ix = W.indexOf(w)
        w = W[ix-1]
        W.remove(p*w)
    }
}

var sieveOfPritchard = Fn.new { |N|
    if (N < 2) return []
    var W  = SortedList.fromOne(1)
    var Pr = SortedList.fromOne(2)
    var k = 1
    var length = 2
    var p = 3
    while (p * p <= N) {
        if (length < N) {
            var n = N.min(p*length)
            extend.call(W, length, n)
            length = n
        }
        deleteMultiples.call(W, length, p)
        Pr.add(p)
        k = k + 1
        p = W[1]
    }
    if (length < N) extend.call(W, length, N)
    return (Pr + W)[1..-1]
}

Fmt.tprint("$3d", sieveOfPritchard.call(150), 7)
