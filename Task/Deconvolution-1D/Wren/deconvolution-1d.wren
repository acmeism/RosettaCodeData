var deconv = Fn.new { |g, f|
    var h = List.filled(g.count - f.count + 1, 0)
    for (n in 0...h.count) {
        h[n] = g[n]
        var lower = (n >= f.count) ? n - f.count + 1 : 0
        var i = lower
        while (i < n) {
            h[n] = h[n] - h[i]*f[n-i]
            i = i + 1
        }
        h[n] = h[n] / f[0]
    }
    return h
}

var h = [-8, -9, -3, -1, -6, 7]
var f = [-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1]
var g = [24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7]
System.print(h)
System.print(deconv.call(g, f))
System.print(f)
System.print(deconv.call(g, h))
