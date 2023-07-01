import "/complex" for Complex
import "/fmt" for Fmt

var fft2 // recursive
fft2 = Fn.new { |buf, out, n, step, start|
    if (step < n) {
        fft2.call(out, buf, n, step*2, start)
        fft2.call(out, buf, n, step*2, start + step)
        var j = 0
        while (j < n) {
            var t = (Complex.imagMinusOne * Num.pi * j / n).exp * out[j+step+start]
            buf[(j/2).floor + start] = out[j+start] + t
            buf[((j+n)/2).floor + start] = out[j+start] - t
            j = j + 2 * step
        }
    }
}

var fft = Fn.new { |buf, n|
    var out = List.filled(n, null)
    for (i in 0...n) out[i] = buf[i]
    fft2.call(buf, out, n, 1, 0)
}

/* pad list length to power of two */
var padTwo = Fn.new { |g, le, nsl|
    var n = 1
    var ns = nsl[0]
    if (ns != 0) {
        n = ns
    } else {
        while (n < le) n = n * 2
    }
    var buf = List.filled(n, Complex.zero)
    for (i in 0...le) buf[i] = Complex.new(g[i], 0)
    nsl[0] = n
    return buf
}

var deconv = Fn.new { |g, lg, f, lf, out, rowLe|
    var ns = 0
    var nsl = [ns]
    var g2 = padTwo.call(g, lg, nsl)
    var f2 = padTwo.call(f, lf, nsl)
    ns = nsl[0]
    fft.call(g2, ns)
    fft.call(f2, ns)
    var h = List.filled(ns, null)
    for (i in 0...ns) h[i] = g2[i] / f2[i]
    fft.call(h, ns)
    for (i in 0...ns) {
        if (h[i].real.abs < 1e-10) h[i] = Complex.zero
    }
    var i = 0
    while (i > lf-lg-rowLe) {
        out[-i] = (h[(i+ns)%ns]/32).real
        i = i - 1
    }
}

var unpack2 = Fn.new { |m, rows, le, toLe|
    var buf = List.filled(rows*toLe, 0)
    for (i in 0...rows) {
        for (j in 0...le) buf[i*toLe+j] = m[i][j]
    }
    return buf
}

var pack2 = Fn.new { |buf, rows, fromLe, toLe, out|
    for (i in 0...rows) {
        for (j in 0...toLe) out[i][j] = buf[i*fromLe+j] / 4
    }
}

var deconv2 = Fn.new { |g, rowG, colG, f, rowF, colF, out|
    var g2 = unpack2.call(g, rowG, colG, colG)
    var f2 = unpack2.call(f, rowF, colF, colG)
    var ff = List.filled((rowG-rowF+1)*colG, 0)
    deconv.call(g2, rowG*colG, f2, rowF*colG, ff, colG)
    pack2.call(ff, rowG-rowF+1, colG, colG-colF+1, out)
}

var unpack3 = Fn.new { |m, x, y, z, toY, toZ|
    var buf = List.filled(x*toY*toZ, 0)
    for (i in 0...x) {
        for (j in 0...y) {
            for (k in 0...z) {
                buf[(i*toY+j)*toZ+k] = m[i][j][k]
            }
        }
    }
    return buf
}

var pack3 = Fn.new { |buf, x, y, z, toY, toZ, out|
    for (i in 0...x) {
        for (j in 0...toY) {
            for (k in 0...toZ) {
                out[i][j][k] = buf[(i*y+j)*z+k] / 4
            }
        }
    }
}

var deconv3 = Fn.new { |g, gx, gy, gz, f, fx, fy, fz, out|
    var g2 = unpack3.call(g, gx, gy, gz, gy, gz)
    var f2 = unpack3.call(f, fx, fy, fz, gy, gz)
    var ff = List.filled((gx-fx+1)*gy*gz, 0)
    deconv.call(g2, gx*gy*gz, f2, fx*gy*gz, ff, gy*gz)
    pack3.call(ff, gx-fx+1, gy, gz, gy-fy+1, gz-fz+1, out)
}

var f = [
    [[-9,  5, -8], [ 3,  5,  1]],
    [[-1, -7,  2], [-5, -6,  6]],
    [[ 8,  5,  8], [-2, -6, -4]]
]
var fx = f.count
var fy = f[0].count
var fz = f[0][0].count

var g = [
    [[ 54, 42, 53, -42, 85, -72], [45, -170, 94, -36, 48, 73],
     [-39, 65, -112, -16, -78, -72], [6, -11, -6, 62, 49,  8]],
    [[-57, 49, -23, 52, -135, 66], [-23, 127, -58, -5, -118, 64],
     [ 87, -16, 121, 23, -41, -12], [-19, 29, 35, -148, -11, 45]],
    [[-55, -147, -146, -31, 55, 60], [-88, -45, -28, 46, -26, -144],
     [-12, -107, -34, 150, 249, 66], [11, -15, -34, 27, -78, -50]],
    [[ 56, 67, 108, 4, 2, -48], [58, 67, 89, 32, 32, -8],
     [-42, -31, -103, -30, -23, -8], [6, 4, -26, -10, 26, 12]]
]

var gx = g.count
var gy = g[0].count
var gz = g[0][0].count

var h = [
    [[-6, -8, -5,  9], [-7, 9, -6, -8], [ 2, -7,  9,  8]],
    [[ 7,  4,  4, -6], [ 9, 9,  4, -4], [-3,  7, -2, -3]]
]

var hx = gx - fx + 1
var hy = gy - fy + 1
var hz = gz - fz + 1

var h2 = List.filled(hx, null)
for (i in 0...hx) {
    h2[i] = List.filled(hy, 0)
    for (j in 0...hy) h2[i][j] = List.filled(hz, 0)
}
deconv3.call(g, gx, gy, gz, f, fx, fy, fz, h2)
System.print("deconv3(g, f):\n")
for (i in 0...hx) {
    for (j in 0...hy) {
        for (k in 0...hz) Fmt.write("$9.6h ", h2[i][j][k])
        System.print()
    }
    if (i < hx-1) System.print()
}

var kx = gx - hx + 1
var ky = gy - hy + 1
var kz = gz - hz + 1
var f2 = List.filled(kx, null)
for (i in 0...kx) {
    f2[i] = List.filled(ky, 0)
    for (j in 0...ky) f2[i][j] = List.filled(kz, 0)
}
deconv3.call(g, gx, gy, gz, h, hx, hy, hz, f2)
System.print("\ndeconv3(g, h):\n")
for (i in 0...kx) {
    for (j in 0...ky) {
        for (k in 0...kz) Fmt.write("$9.6h ", f2[i][j][k])
        System.print()
    }
    if (i < kx-1) System.print()
}
