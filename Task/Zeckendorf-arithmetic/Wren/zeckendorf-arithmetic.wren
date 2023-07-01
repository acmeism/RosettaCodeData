import "/trait" for Comparable

class Zeckendorf is Comparable {
    static dig  { ["00", "01", "10"] }
    static dig1 { ["", "1", "10"] }

    construct new(x) {
        var q = 1
        var i = x.count - 1
        _dLen = (i / 2).floor
        _dVal = 0
        while (i >= 0) {
            _dVal = _dVal + (x[i].bytes[0] - 48) * q
            q = q * 2
            i = i - 1
        }
    }

    dLen { _dLen }
    dVal { _dVal }

    dLen=(v) { _dLen = v }
    dVal=(v) { _dVal = v }

    a(n) {
        var i = n
        while (true) {
            if (_dLen < i) _dLen = i
            var j = (_dVal >> (i * 2)) & 3
            if (j == 0 || j == 1) return
            if (j == 2) {
                if (((_dVal >> ((i + 1) * 2)) & 1) != 1) return
                _dVal = _dVal + (1 << (i * 2 + 1))
                return
            }
            if (j == 3) {
                _dVal = _dVal & ~(3 << (i * 2))
                b((i + 1) * 2)
            }
            i = i + 1
        }
    }

    b(pos) {
        if (pos == 0) {
            var thiz = this
            thiz.inc
            return
        }
        if (((_dVal >> pos) & 1) == 0) {
            _dVal = _dVal + (1 << pos)
            a((pos / 2).floor)
            if (pos > 1) a((pos / 2).floor - 1)
        } else {
            _dVal = _dVal & ~(1 << pos)
            b(pos + 1)
            b(pos - ((pos > 1) ? 2 : 1))
        }
    }

    c(pos) {
        if (((_dVal >> pos) & 1) == 1) {
            _dVal = _dVal & ~(1 << pos)
            return
        }
        c(pos + 1)
        if (pos > 0) {
            b(pos - 1)
        } else {
            var thiz = this
            thiz.inc
        }
    }

    inc {
        _dVal = _dVal + 1
        a(0)
        return this
    }

    plusAssign(other) {
        for (gn in 0...(other.dLen + 1) * 2) {
            if (((other.dVal >> gn) & 1) == 1) b(gn)
        }
    }

    minusAssign(other) {
        for (gn in 0...(other.dLen + 1) * 2) {
            if (((other.dVal >> gn) & 1) == 1) c(gn)
        }
        while ((((_dVal >> _dLen * 2) & 3) == 0) || (_dLen == 0)) _dLen = _dLen - 1
    }

    timesAssign(other) {
        var na = other.copy()
        var nb = other.copy()
        var nr = Zeckendorf.new("0")
        for (i in 0..(_dLen + 1) * 2) {
            if (((_dVal >> i) & 1) > 0) nr.plusAssign(nb)
            var nt = nb.copy()
            nb.plusAssign(na)
            na = nt.copy()
        }
        _dVal = nr.dVal
        _dLen = nr.dLen
    }

    compare(other) { (_dVal - other.dVal).sign }

    toString {
        if (_dVal == 0) return "0"
        var sb = Zeckendorf.dig1[(_dVal >> (_dLen * 2)) & 3]
        if (_dLen > 0) {
            for (i in _dLen - 1..0) {
                sb = sb + Zeckendorf.dig[(_dVal >> (i * 2)) & 3]
            }
        }
        return sb
    }

    copy() {
        var z = Zeckendorf.new("0")
        z.dVal = _dVal
        z.dLen = _dLen
        return z
    }
}

var Z = Zeckendorf // type alias
System.print("Addition:")
var g = Z.new("10")
g.plusAssign(Z.new("10"))
System.print(g)
g.plusAssign(Z.new("10"))
System.print(g)
g.plusAssign(Z.new("1001"))
System.print(g)
g.plusAssign(Z.new("1000"))
System.print(g)
g.plusAssign(Z.new("10101"))
System.print(g)
System.print("\nSubtraction:")
g = Z.new("1000")
g.minusAssign(Z.new("101"))
System.print(g)
g = Z.new("10101010")
g.minusAssign(Z.new("1010101"))
System.print(g)
System.print("\nMultiplication:")
g = Z.new("1001")
g.timesAssign(Z.new("101"))
System.print(g)
g = Z.new("101010")
g.plusAssign(Z.new("101"))
System.print(g)
