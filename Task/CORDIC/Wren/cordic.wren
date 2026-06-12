import "./fmt" for Fmt

// The following are pre-computed to avoid using atan and sqrt functions.
var angles = [
    0.78539816339745, 0.46364760900081, 0.24497866312686, 0.12435499454676,
    0.06241880999596, 0.03123983343027, 0.01562372862048, 0.00781234106010,
    0.00390623013197, 0.00195312251648, 0.00097656218956, 0.00048828121119,
    0.00024414062015, 0.00012207031189, 0.00006103515617, 0.00003051757812,
    0.00001525878906, 0.00000762939453, 0.00000381469727, 0.00000190734863,
    0.00000095367432, 0.00000047683716, 0.00000023841858, 0.00000011920929,
    0.00000005960464, 0.00000002980232, 0.00000001490116, 0.00000000745058
]

var kvalues = [
    0.70710678118655, 0.63245553203368, 0.61357199107790, 0.60883391251775,
    0.60764825625617, 0.60735177014130, 0.60727764409353, 0.60725911229889,
    0.60725447933256, 0.60725332108988, 0.60725303152913, 0.60725295913894,
    0.60725294104140, 0.60725293651701, 0.60725293538591, 0.60725293510314,
    0.60725293503245, 0.60725293501477, 0.60725293501035, 0.60725293500925,
    0.60725293500897, 0.60725293500890, 0.60725293500889, 0.60725293500888
]

var PI = Num.pi

var radians = Fn.new { |d| d * PI / 180 }

var Cordic = Fn.new { |alpha, n|
    var newsgn = ((alpha / (2 * PI)).floor % 2 == 1) ? 1 : -1
    if (alpha < -PI/2) {
        var res = Cordic.call(alpha + PI, n)
        return [newsgn * res[0], newsgn * res[1]]
    }
    if (alpha >  PI/2) {
        var res = Cordic.call(alpha - PI, n)
        return [newsgn * res[0], newsgn * res[1]]
    }
    var kn = kvalues[(n-1).min(kvalues.count-1)]
    var theta = 0
    var x = 1
    var y = 0
    var pow2 = 1
    for (atan in angles[0...n]) {
        var sigma = (theta < alpha) ? 1 : -1
        theta = theta + sigma * atan
        var t = x
        x = x - sigma * y * pow2
        y = y + sigma * t * pow2
        pow2 = pow2 / 2
    }
    return [x * kn, y * kn]
}

Fmt.print("  x       sin(x)     diff. sine     cos(x)    diff. cosine")
var f = "$+5.1f°  $+.8f ($+.8f) $+.8f ($+.8f)"

var th = -90
while (th <= 90) {
    var thr = radians.call(th)
    var res = Cordic.call(thr, 24)
    var cos = res[0]
    var sin = res[1]
    Fmt.print(f, th, sin, sin - thr.sin, cos, cos - thr.cos)
    th = th + 15
}
f = "$+5.1f°  $+.8f ($+.8f) $+.8f ($+.8f)"
Fmt.print("\nx(rads)   sin(x)     diff. sine     cos(x)    diff. cosine ")
f = "$+4.1f    $+.8f ($+.8f) $+.8f ($+.8f)"
for (thr in [-9, 0, 1.5, 6]) {
    var res = Cordic.call(thr, 24)
    var cos = res[0]
    var sin = res[1]
    Fmt.print(f, thr, sin, sin - thr.sin, cos, cos - thr.cos)
}
