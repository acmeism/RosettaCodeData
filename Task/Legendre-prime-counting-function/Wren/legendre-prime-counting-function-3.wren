import "./math" for Int

var masks = [1, 2, 4, 8, 16, 32, 64, 128]

var half = Fn.new { |n| (n - 1) >> 1 }

var countPrimes = Fn.new { |n|
    if (n < 9) return (n < 2) ? 0 : ((n + 1)/2).floor
    var rtlmt = n.sqrt.floor
    var mxndx = Int.quo(rtlmt - 1, 2)
    var arrlen = mxndx + 1
    var smalls = List.filled(arrlen, 0)
    var roughs = List.filled(arrlen, 0)
    var larges = List.filled(arrlen, 0)
    for (i in 0...arrlen) {
        smalls[i] = i
        roughs[i] = i + i + 1
        larges[i] = Int.quo(Int.quo(n, i + i + 1) - 1 , 2)
    }
    var cullbuflen = Int.quo(mxndx + 8, 8)
    var cullbuf = List.filled(cullbuflen, 0)
    var nbps = 0
    var rilmt = arrlen
    var i = 1
    while (true) {
        var sqri = (i + i) * (i + 1)
        if (sqri > mxndx) break
        if ((cullbuf[i >> 3] & masks[i & 7]) != 0) {
            i = i + 1
            continue
        }
        cullbuf[i >> 3] = cullbuf[i >> 3] | masks[i & 7]
        var bp = i + i + 1
        var c = sqri
        while (c < arrlen) {
            cullbuf[c >> 3] = cullbuf[c >> 3] | masks[c & 7]
            c = c + bp
        }
        var nri = 0
        for (ori in 0...rilmt) {
            var r = roughs[ori]
            var rci = r >> 1
            if ((cullbuf[rci >> 3] & masks[rci & 7]) != 0) continue
            var d = r * bp
            var t = (d <= rtlmt) ? larges[smalls[d >> 1] - nbps] :
                                   smalls[half.call(Int.quo(n, d))]
            larges[nri] = larges[ori] - t + nbps
            roughs[nri] = r
            nri = nri + 1
        }
        var si = mxndx
        var pm = ((rtlmt/bp).floor - 1) | 1
        while (pm >= bp) {
            var c = smalls[pm >> 1]
            var e = (pm * bp) >> 1
            while (si >= e) {
                smalls[si] = smalls[si] - c + nbps
                si = si - 1
            }
            pm = pm - 2
        }
        rilmt = nri
        nbps = nbps + 1
        i = i + 1
    }
    var ans = larges[0] + ((rilmt + 2 * (nbps - 1)) * (rilmt - 1) / 2).floor
    for (ri in 1...rilmt) ans = ans - larges[ri]
    var ri = 1
    while (true) {
        var p = roughs[ri]
        var m = Int.quo(n, p)
        var ei = smalls[half.call(Int.quo(m, p))] - nbps
        if (ei <= ri) break
        ans = ans - (ei - ri) * (nbps + ri - 1)
        for (sri in (ri + 1..ei)) {
            ans = ans + smalls[half.call(Int.quo(m, roughs[sri]))]
        }
        ri = ri + 1
    }
    return ans + 1
}

var n = 1
for (i in 0..9) {
    System.print("10^%(i)  %(countPrimes.call(n))")
    n = n * 10
}
