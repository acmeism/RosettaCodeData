import "./fmt" for Fmt

var klarnerRado = Fn.new { |n|
    var dst = List.filled(n, 0)
    var i2 = 0
    var i3 = 0
    var m = 0
    var m2 = 1
    var m3 = 1
    for (i in 0...n) {
        dst[i] = m = m2.min(m3)
        if (m2 == m) {
            m2 = dst[i2] << 1 | 1
            i2 = i2 + 1
        }
        if (m3 == m) {
            m3 = dst[i3] * 3 + 1
            i3 = i3 + 1
        }
    }
    return dst
}

var kr = klarnerRado.call(1e7)
System.print("First 100 elements of Klarner-Rado sequence:")
Fmt.tprint("$3d ", kr[0..99], 10)
System.print()
var limits = [1, 10, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7]
for (limit in limits) {
    Fmt.print("The $,r element: $,d", limit, kr[limit-1])
}
