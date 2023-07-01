import "/complex" for Complex
import "/fmt" for Fmt

class QuaterImaginary {
    construct new(b2i) {
       if (b2i.type != String || b2i == "" || !b2i.all { |d| "0123.".contains(d) } ||
           b2i.count { |d| d == "." } > 1) Fiber.abort("Invalid Base 2i number.")
        _b2i = b2i
    }

    // only works properly if 'c.real' and 'c.imag' are both integral
    static fromComplex(c) {
        if (c.real == 0 && c.imag == 0) return QuaterImaginary.new("0")
        var re = c.real.truncate
        var im = c.imag.truncate
        var fi = -1
        var sb = ""
        while (re != 0) {
            var rem = re % (-4)
            re = (re/(-4)).truncate
            if (rem < 0) {
                rem = 4 + rem
                re = re + 1
            }
            if (rem == -0) rem = 0 // get rid of minus zero
            sb = sb + rem.toString + "0"
        }
        if (im != 0) {
            var f = (Complex.new(0, c.imag) / Complex.imagTwo).real
            im = f.ceil
            f = -4 * (f - im)
            var index = 1
            while (im != 0) {
                var rem = im % (-4)
                im = (im/(-4)).truncate
                if (rem < 0) {
                    rem = 4 + rem
                    im = im + 1
                }
                if (index < sb.count) {
                    var sbl = sb.toList
                    sbl[index] = String.fromByte(rem + 48)
                    sb = sbl.join()
                } else {
                    if (rem == -0) rem = 0 // get rid of minus zero
                    sb = sb + "0" + rem.toString
                }
                index = index + 2
            }
            fi = f.truncate
        }
        if (sb.count > 0) sb = sb[-1..0]
        if (fi != -1) {
            if (fi == -0) fi = 0 // get rid of minus zero
            sb = sb + ".%(fi)"
        }
        sb = sb.trimStart("0")
        if (sb.startsWith(".")) sb = "0" + sb
        return QuaterImaginary.new(sb)
    }

    toComplex {
        var pointPos = _b2i.indexOf(".")
        var posLen = (pointPos != -1) ? pointPos : _b2i.count
        var sum = Complex.zero
        var prod = Complex.one
        for (j in 0...posLen) {
            var k = _b2i.bytes[posLen-1-j] - 48
            if (k > 0) sum = sum + prod * k
            prod = prod * Complex.imagTwo
        }
        if (pointPos != -1) {
            prod = Complex.imagTwo.inverse
            var j = posLen + 1
            while (j < _b2i.count) {
                var k = _b2i.bytes[j] - 48
                if (k > 0) sum = sum + prod * k
                prod = prod / Complex.imagTwo
                j = j + 1
            }
        }
        return sum
    }

    toString { _b2i }
}

var imagOnly = Fn.new { |c| c.imag.toString + "i" }

var fmt = "$4s -> $8s -> $4s"
Complex.showAsReal = true
for (i in 1..16) {
    var c1 = Complex.new(i, 0)
    var qi = QuaterImaginary.fromComplex(c1)
    var c2 = qi.toComplex
    Fmt.write("%(fmt)     ", c1, qi, c2)
    c1 = -c1
    qi = QuaterImaginary.fromComplex(c1)
    c2 = qi.toComplex
    Fmt.print(fmt, c1, qi, c2)
}
System.print()
for (i in 1..16) {
    var c1 = Complex.new(0, i)
    var qi = QuaterImaginary.fromComplex(c1)
    var c2 = qi.toComplex
    Fmt.write("%(fmt)     ", imagOnly.call(c1), qi, imagOnly.call(c2))
    c1 = -c1
    qi = QuaterImaginary.fromComplex(c1)
    c2 = qi.toComplex
    Fmt.print(fmt, imagOnly.call(c1), qi, imagOnly.call(c2))
}
