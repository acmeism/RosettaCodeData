/* See original Mathematica example for copyright notice and comments. */

var nbits = 8
var es = 2
var npat = 1 << nbits
var useed = 1 << (1 << es)

var x2p = Fn.new { |x|
    var i
    var p
    var e = 1 << (es - 1)
    var y = x.abs
    if (y == 0) return 0
    if (y.isInfinity) return 1 << (nbits - 1)
    if (y >= 1) {
        p = 1
        i = 2
        while (y >= useed && i < nbits) {
            p = 2 * p + 1
            y = y / useed
            i = i + 1
        }
        p = 2 * p
        i = i + 1
    } else {
        p = 0
        i = 1
        while (y < 1 && i <= nbits) {
            y = y * useed
            i = i + 1
        }
        if (i >= nbits) {
            p = 2
            i = nbits + 1
        } else {
            p = 1
            i = i + 1
        }
    }

    while (e > 0.5 && i <= nbits) {
        p = 2 * p
        if (y >= 2 * e) {
            y = y / (1 << e)
            p = p + 1
        }
        e = e / 2
        i = i + 1
    }
    y = y - 1

    while (y > 0 && i <= nbits) {
        y = 2 * y
        p  = 2 * p + y.floor
        y = y - y.floor
        i = i + 1
    }
    p = p * (1 << (nbits + 1 - i))
    i = i + 1
    i = p & 1
    p = (p/2).floor
    if (i != 0) {
        if (y == 1 || y == 0) {
            p = p + (p & 1)
        } else {
            p = p + 1
        }
    }
    return (x < 0 ? npat - p : p) % npat
}

System.print(x2p.call(Num.pi))
