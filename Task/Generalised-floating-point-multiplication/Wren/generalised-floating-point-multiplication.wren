import "./str" for Str
import "./iterate" for Stepped
import "./fmt" for Fmt

var maxdp           = 81
var binary          = "01"
var ternary         = "012"
var balancedTernary = "-0+"
var decimal         = "0123456789"
var hexadecimal     = "0123456789ABCDEF"
var septemVigesimal = "0123456789ABCDEFGHIJKLMNOPQ"
var balancedBase27  = "ZYXWVUTSRQPON0ABCDEFGHIJKLM"
var base37          = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

// converts Phix indices to Wren
var wIndex = Fn.new { |pIndex, le|
    if (pIndex < 0) return pIndex + le
    return pIndex - 1
}

var getCarry = Fn.new { |digit, base|
    if (digit > base) {
        return 1
    } else if (digit < 1) {
        return -1
    }
    return 0
}

// convert string 'b' to a decimal floating point number
var b2dec = Fn.new { |b, alphabet|
    var res = 0
    var base = alphabet.count
    var zdx = alphabet.indexOf("0") + 1
    var signed = zdx == 1 && b[0] == "-"
    if (signed) b = b[1..-1]
    var le = b.count
    var ndp = b.indexOf(".") + 1
    if (ndp != 0) {
        b = Str.delete(b, ndp - 1) // remove decimal point
        ndp = le - ndp
    }
    for (i in Stepped.ascend(1..b.count)) {
        var idx = alphabet.indexOf(b[i-1]) + 1
        res = base * res + idx - zdx
    }
    if (ndp != 0) res = res / base.pow(ndp)
    if (signed) res = -res
    return res
}

// string 'b' can be balanced or unbalanced
var negate = Fn.new { |b, alphabet|
    if (alphabet[0] == "0") {
        if (b != "0") b = (b[0] == "-") ? b[1..-1] : Str.insert(b, 0, "-")
    } else {
        for (i in Stepped.ascend(1..b.count)) {
            if (b[i-1] != ".") {
                var idx = alphabet.indexOf(b[i-1]) + 1
                var wi = wIndex.call(-idx, alphabet.count)
                b = Str.change(b, i-1, alphabet[wi])
            }
        }
    }
    return b
}

var bTrim = Fn.new { |b|
    // trim  trailing ".000"
    var idx = b.indexOf(".") + 1
    if (idx != 0) b = b.trimEnd("0").trimEnd(".")
    // trim leading zeros but not "0.nnn"
    while (b.count > 1 && b[0] == "0" && b[1] != ".") b = b[1..-1]
    return b
}

// for balanced number systems only
var bCarry = Fn.new { |digit, base, idx, n, alphabet|
    var carry = getCarry.call(digit, base)
    if (carry != 0) {
        for (i in Stepped.descend(idx..1)) {
            if (n[i-1] != ".") {
                var k = alphabet.indexOf(n[i-1]) + 1
                if (k < base) {
                    n = Str.change(n, i-1, alphabet[k])
                    break
                }
                n = Str.change(n, i-1, alphabet[0])
            }
        }
        digit = digit - base * carry
    }
    return [digit, n]
}

// convert a string from alphabet to alphabet2
var b2b // recursive function
b2b = Fn.new { |n, alphabet, alphabet2|
    var res = "0"
    var m = ""
    if (n != "0") {
        var base = alphabet.count
        var base2 = alphabet2.count
        var zdx = alphabet.indexOf("0") + 1
        var zdx2 = alphabet2.indexOf("0") + 1
        var carry = 0
        var q = 0
        var r = 0
        var digit = 0
        var idx = alphabet.indexOf(n[0]) + 1
        var negative = (zdx == 1 && n[0] == "-") || (zdx != 1 && idx < zdx)
        if (negative) n = negate.call(n, alphabet)
        var ndp = n.indexOf(".") + 1
        if (ndp != 0) {
            var t = n
            n = n[0...ndp-1]
            m = t[ndp..-1]
        }
        res = ""
        while (n.count > 0) {
            q = 0
            for (i in Stepped.ascend(1..n.count)) {
                digit = alphabet.indexOf(n[i-1]) + 1 - zdx
                q = q*base + digit
                r = q.abs % base2
                digit = (q.abs/base2).floor + zdx
                if (q < 0) digit = digit - 1
                if (zdx != 1) {
                    var p = bCarry.call(digit, base, i-1, n, alphabet)
                    digit = p[0]
                    n = p[1]
                }
                n = Str.change(n, i-1, alphabet[digit-1])
                q = r
            }
            r = r + zdx2
            if (zdx2 != 1) {
                r = r + carry
                carry = getCarry.call(r, base2)
                r = r - base2 * carry
            }
            res = Str.insert(res, 0, alphabet2[r-1])
            n = n.trimStart("0")
        }
        if (carry != 0) res = Str.insert(res, 0, alphabet2[carry+zdx2-1])
        if (m.count > 0) {
            res = res + "."
            ndp = 0
            if (zdx != 1) {
                var lm = m.count
                var alphaNew = base37[0...alphabet.count]
                m = b2b.call(m, alphabet, alphaNew)
                m = ("0" * (lm-m.count)) + m
                alphabet = alphaNew
                zdx = 1
            }
            while (m.count > 0 && ndp < maxdp) {
                q = 0
                for (i in Stepped.descend(m.count..1)) {
                    digit = alphabet.indexOf(m[i-1]) + 1 - zdx
                    q = q + digit * base2
                    r = q.abs % base + zdx
                    q = (q / base).truncate
                    if (q < 0) q = q - 1
                    m = Str.change(m, i-1, alphabet[r-1])
                }
                digit = q + zdx2
                if (zdx2 != 1) {
                    var p = bCarry.call(digit, base2, res.count, res, alphabet2)
                    digit = p[0]
                    res = p[1]
                }
                res = res + alphabet2[digit-1]
                m = m.trimEnd("0")
                ndp = ndp + 1
            }
        }
        res = bTrim.call(res)
        if (negative) res = negate.call(res, alphabet2)
    }
    return res
}

// convert 'd' to a string in the specified base
var float2b = Fn.new { |d, alphabet|
    var base = alphabet.count
    var zdx = alphabet.indexOf("0") + 1
    var carry = 0
    var neg = d < 0
    if (neg) d = -d
    var res = ""
    var whole = d.floor
    d = d - whole
    while (true) {
        var ch = whole % base + zdx
        if (zdx != 1) {
            ch = ch + carry
            carry = getCarry.call(ch, base)
            ch = ch - base * carry
        }
        res = Str.insert(res, 0, alphabet[ch-1])
        whole = (whole / base).truncate
        if (whole == 0) break
    }
    if (carry != 0) {
        res = Str.insert(res, 0, alphabet[carry+zdx-1])
        carry = 0
    }
    if (d != 0) {
        res = res + "."
        var ndp = 0
        while (d != 0 && ndp < maxdp) {
            d = d * base
            var digit = d.truncate + zdx
            d = d - digit
            if (zdx != 1) {
                var p = bCarry.call(digit, base, res.count, res, alphabet)
                digit = p[0]
                res = p[1]
            }
            res = res + alphabet[digit-1]
            ndp = ndp + 1
        }
    }
    if (neg) res = negate.call(res, alphabet)
    return res
}

var bSub // forwward declaration

var bAdd = Fn.new { |a, b, alphabet|
    var base = alphabet.count
    var zdx = alphabet.indexOf("0") + 1
    var carry = 0
    var da = 0
    var db = 0
    var digit = 0
    if (zdx == 1) {
        if (a[0] == "-") {
            return bSub.call(b, negate.call(a, alphabet), alphabet)
        }
        if (b[0] == "-") {
            return bSub.call(a, negate.call(b, alphabet), alphabet)
        }
    }
    var adt = a.indexOf(".") + 1
    var bdt = b.indexOf(".") + 1
    if (adt != 0 || bdt != 0) {
        if (adt != 0) {
            adt = a.count - adt + 1
            var wi = wIndex.call(-adt, a.count)
            a = Str.delete(a, wi)
        }
        if (bdt != 0) {
            bdt = b.count - bdt + 1
            var wi = wIndex.call(-bdt, b.count)
            b = Str.delete(b, wi)
        }
        if (bdt > adt) {
            a = a + ("0" * (bdt-adt))
            adt = bdt
        } else if (adt > bdt) {
            b = b + ("0" * (adt-bdt))
        }
    }
    if (a.count < b.count) {
       var t = a
       a = b
       b = t
    }
    for (i in Stepped.descend(-1..-a.count)) {
        if (i < -a.count) {
            da = 0
        } else {
            da = alphabet.indexOf(a[a.count + i]) + 1 - zdx
        }
        if (i < -b.count) {
            db = 0
        } else {
            db = alphabet.indexOf(b[b.count + i]) + 1 - zdx
        }
        digit = da + db + carry + zdx
        carry = getCarry.call(digit, base)
        a = Str.change(a, i + a.count, alphabet[digit-carry*base-1])
        if (i < -b.count && carry == 0) break
    }
    if (carry != 0) {
        a = Str.insert(a, 0, alphabet[carry+zdx-1])
    }
    if (adt != 0) {
        var wi = wIndex.call(-adt+1, a.count)
        a = Str.insert(a, wi, ".")
    }
    a = bTrim.call(a)
    return a
}

var aSmaller = Fn.new { |a, b, alphabet|
    if (a.count != b.count) Fiber.abort("strings should be equal in length")
    for (i in Stepped.ascend(1..a.count)) {
        var da = alphabet.indexOf(a[i-1]) + 1
        var db = alphabet.indexof(b[i-1]) + 1
        if (da != db) return da < db
    }
    return false
}

// declared earlier
bSub = Fn.new { |a, b, alphabet|
    var base = alphabet.count
    var zdx = alphabet.indexOf("0") + 1
    var carry = 0
    var da = 0
    var db = 0
    var digit = 0
    if (zdx == 1) {
        if (a[0] == "-") {
            return negate.call(bAdd.call(negate.call(a, alphabet), b, alphabet), alphabet)
        }
        if (b[0] == "-") {
            return bAdd.call(a, negate.call(b, alphabet), alphabet)
        }
    }
    var adt = a.indexOf(".") + 1
    var bdt = b.indexOf(".") + 1
    if (adt != 0 || bdt != 0) {
        if (adt != 0) {
            adt = a.count - adt + 1
            var wi = wIndex.call(-adt, a.count)
            a = Str.delete(a, wi)
        }
        if (bdt != 0) {
            bdt = b.count - bdt + 1
            var wi = wIndex.call(-bdt, b.count)
            b = Str.delete(b, wi)
        }
        if (bdt > adt) {
            a = a + ("0" * (bdt-adt))
            adt = bdt
        } else if (adt > bdt) {
            b = b + ("0" * (adt-bdt))
        }
    }
    var bNegate = false
    if (a.count < b.count || (a.count == b.count && aSmaller.call(a, b, alphabet))) {
        bNegate = true
        var t = a
        a = b
        b = t
    }
    for (i in Stepped.descend(-1..-a.count)) {
        if (i < -a.count) {
            da = 0
        } else {
            da = alphabet.indexOf(a[a.count+i]) + 1 - zdx
        }
        if (i < -b.count) {
            db = 0
        } else {
            db = alphabet.indexOf(b[b.count+i]) + 1 - zdx
        }
        digit = da - db - carry + zdx
        carry = 0
        if (digit <= 0) carry = 1
        a = Str.change(a, i+a.count, alphabet[digit+carry*base-1])
        if (i < -b.count && carry == 0) break
    }
    if (carry != 0) Fiber.abort("carry should be zero")
    if (adt != 0) {
        var wi = wIndex.call(-adt+1, a.count)
        a = Str.insert(a, wi, ".")
    }
    a = bTrim.call(a)
    if (bNegate) a = negate.call(a, alphabet)
    return a
}

var bMul = Fn.new { |a, b, alphabet|
    var zdx = alphabet.indexOf("0") + 1
    var dpa = a.indexOf(".") + 1
    var dpb = b.indexOf(".") + 1
    var ndp = 0
    if (dpa != 0) {
        ndp = ndp + a.count - dpa
        a = Str.delete(a, dpa-1)
    }
    if (dpb != 0) {
        ndp = ndp + b.count - dpb
        b = Str.delete(b, dpb-1)
    }
    var pos = a
    var res = "0"
    if (zdx != 1) {
        // balanced number systems
        var neg = negate.call(pos, alphabet)
        for (i in Stepped.descend(b.count..1)) {
            var m = alphabet.indexOf(b[i-1]) + 1 - zdx
            while (m != 0) {
                var temp = pos
                var temp2 = -1
                if (m < 0) {
                    temp = neg
                    temp2 = 1
                }
                res = bAdd.call(res, temp, alphabet)
                m = m + temp2
            }
            pos = pos + "0"
            neg = neg + "0"
        }
    } else {
        // non-balanced number systems
        var negative = false
        if (a[0] == "-") {
            a = a[1..-1]
            negative = true
        }
        if (b[0] == "-") {
            b = b[1..-1]
            negative = !negative
        }
        for (i in Stepped.descend(b.count..1)) {
            var m = alphabet.indexOf(b[i-1]) + 1 - zdx
            while (m > 0) {
                res = bAdd.call(res, pos, alphabet)
                m = m - 1
            }
            pos = pos + "0"
        }
        if (negative) res = negate.call(res, alphabet)
    }
    if (ndp != 0) {
        var wi = wIndex.call(-ndp, res.count)
        res = Str.insert(res, wi, ".")
    }
    res = bTrim.call(res)
    return res
}

var multTable = Fn.new {
    System.print("multiplication table")
    System.print("====================")
    System.write("* |")
    for (j in 1..12) {
        Fmt.write(" #$s $3s |", float2b.call(j, hexadecimal), float2b.call(j, balancedTernary))
    }
    for (i in 1..27) {
        var a = float2b.call(i, balancedTernary)
        Fmt.write("\n$-2s|", float2b.call(i, septemVigesimal))
        for (j in 1..12) {
            if (j > i) {
                System.write("        |")
            } else {
                var b = float2b.call(j, balancedTernary)
                var m = bMul.call(a, b, balancedTernary)
                Fmt.write(" $6s |", m)
            }
        }
    }
    System.print()
}

var test = Fn.new {|name, alphabet|
    var a = b2b.call("+-0++0+.+-0++0+", balancedTernary, alphabet)
    var b = b2b.call("-436.436", decimal, alphabet)
    var c = b2b.call("+-++-.+-++-", balancedTernary, alphabet)
    var d = bSub.call(b, c, alphabet)
    var r = bMul.call(a, d, alphabet)
    Fmt.print("$s\n$s", name, "=" * name.count)
    Fmt.print("      a = $.14f $s", b2dec.call(a, alphabet), a)
    Fmt.print("      b = $.14f $s", b2dec.call(b, alphabet), b)
    Fmt.print("      c = $.14f $s", b2dec.call(c, alphabet), c)
    Fmt.print("a*(b-c) = $.14f $s\n", b2dec.call(r, alphabet), r)
}

test.call("balanced ternary", balancedTernary)
test.call("balanced base 27", balancedBase27)
test.call("decimal", decimal)
test.call("binary", binary)
test.call("ternary", ternary)
test.call("hexadecimal", hexadecimal)
test.call("septemvigesimal", septemVigesimal)
multTable.call()
