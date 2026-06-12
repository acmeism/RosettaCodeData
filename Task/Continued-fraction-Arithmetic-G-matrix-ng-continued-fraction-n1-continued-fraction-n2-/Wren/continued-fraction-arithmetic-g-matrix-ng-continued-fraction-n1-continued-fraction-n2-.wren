class MatrixNG {
    construct new() {
       _cfn = 0
       _thisTerm = 0
       _haveTerm = false
    }
    cfn     { _cfn }
    cfn=(v) { _cfn = v }

    thisTerm     { _thisTerm }
    thisTerm=(v) { _thisTerm = v }

    haveTerm     { _haveTerm }
    haveTerm=(v) { _haveTerm = v }

    consumeTerm() {}
    consumeTerm(n) {}
    needTerm() {}
}

class NG4 is MatrixNG {
    construct new(a1, a, b1, b) {
        super()
        _a1 = a1
        _a  = a
        _b1 = b1
        _b  = b
        _t  = 0
    }

    needTerm() {
        if (_b1 == 0 && _b == 0) return false
        if (_b1 == 0 || _b == 0) return true
        thisTerm = (_a / _b).truncate
        if (thisTerm ==  (_a1 / _b1).truncate) {
            _t = _a
            _a = _b
            _b = _t - _b  * thisTerm
            _t = _a1
            _a1 = _b1
            _b1 = _t - _b1 * thisTerm
            haveTerm = true
            return false
        }
        return true
    }

    consumeTerm() {
        _a = _a1
        _b = _b1
    }

    consumeTerm(n) {
        _t = _a
        _a = _a1
        _a1 = _t + _a1 * n
        _t = _b
        _b = _b1
        _b1 = _t + _b1 * n
    }
}

class NG8 is MatrixNG {
    construct new(a12, a1, a2, a, b12, b1, b2, b) {
        super()
        _a12 = a12
        _a1  = a1
        _a2  = a2
        _a   = a
        _b12 = b12
        _b1  = b1
        _b2  = b2
        _b   = b
        _t   = 0
        _ab  = 0

        _a1b1 = 0
        _a2b2 = 0

        _a12b12 = 0
    }

    chooseCFN() { ((_a1b1 - _ab).abs > (_a2b2 - _ab).abs) ? 0 : 1 }

    needTerm() {
        if (_b1 == 0 && _b == 0 && _b2 == 0 && _b12 == 0) return false
        if (_b == 0) {
            cfn = (_b2 == 0) ? 0 : 1
            return true
        } else _ab = _a/_b

        if (_b2 == 0) {
            cfn = 1
            return true
        } else _a2b2 = _a2/_b2

        if (_b1 == 0) {
            cfn = 0
            return true
        } else _a1b1 = _a1/_b1

        if (_b12 == 0) {
            cfn = chooseCFN()
            return true
        } else _a12b12 = _a12/_b12

        thisTerm = _ab.truncate
        if (thisTerm == _a1b1.truncate && thisTerm == _a2b2.truncate &&
            thisTerm == _a12b12.truncate) {
            _t = _a
            _a = _b
            _b = _t - _b * thisTerm
            _t = _a1
            _a1 = _b1
            _b1 = _t - _b1 * thisTerm
            _t = _a2
            _a2 = _b2
            _b2 = _t - _b2 * thisTerm
            _t = _a12
            _a12 = _b12
            _b12 = _t - _b12 * thisTerm
            haveTerm = true
            return false
        }
        cfn = chooseCFN()
        return true
    }

    consumeTerm() {
        if (cfn == 0) {
            _a  = _a1
            _a2 = _a12
            _b  = _b1
            _b2 = _b12
        } else {
            _a  = _a2
            _a1 = _a12
            _b  = _b2
            _b1 = _b12
        }
    }

    consumeTerm(n) {
        if (cfn == 0) {
            _t = _a
            _a = _a1
            _a1 = _t + _a1 * n
            _t = _a2
            _a2 = _a12
            _a12 = _t + _a12 * n
            _t = _b
            _b = _b1
            _b1 = _t + _b1 * n
            _t = _b2
            _b2 = _b12
            _b12 = _t + _b12 * n
        } else {
            _t = _a
            _a = _a2
            _a2 = _t + _a2 * n
            _t = _a1
            _a1 = _a12
            _a12 = _t + _a12 * n
            _t = _b
            _b = _b2
            _b2 = _t +  _b2 * n
            _t = _b1
            _b1 = _b12
            _b12 = _t + _b12 * n
        }
    }
}

class ContinuedFraction {
    nextTerm() {}
    moreTerms() {}
}

class R2cf is ContinuedFraction {
    construct new(n1, n2) {
        _n1 = n1
        _n2 = n2
    }

    nextTerm() {
        var thisTerm = (_n1/_n2).truncate
        var t2 = _n2
        _n2 = _n1 - thisTerm * _n2
        _n1 = t2
        return thisTerm
    }

    moreTerms() { _n2.abs > 0 }
}

class NG is ContinuedFraction {
    construct new(ng, n1) {
        _ng = ng
        _n = [n1]
    }

    construct new(ng, n1, n2) {
        _ng = ng
        _n = [n1, n2]
    }

    nextTerm() {
        _ng.haveTerm = false
        return _ng.thisTerm
    }

    moreTerms() {
        while (_ng.needTerm()) {
            if (_n[_ng.cfn].moreTerms()) {
                _ng.consumeTerm(_n[_ng.cfn].nextTerm())
            } else {
                _ng.consumeTerm()
            }
        }
        return _ng.haveTerm
    }
}

var test = Fn.new { |desc, cfs|
    System.print("TESTING -> %(desc)")
    for (cf in cfs) {
        while (cf.moreTerms()) System.write("%(cf.nextTerm()) ")
        System.print()
    }
    System.print()
}

var a  = NG8.new(0, 1, 1, 0, 0, 0, 0, 1)
var n2 = R2cf.new(22, 7)
var n1 = R2cf.new(1, 2)
var a3 = NG4.new(2, 1, 0, 2)
var n3 = R2cf.new(22, 7)
test.call("[3;7] + [0;2]", [NG.new(a, n1, n2), NG.new(a3, n3)])

var b  = NG8.new(1, 0, 0, 0, 0, 0, 0, 1)
var b1 = R2cf.new(13, 11)
var b2 = R2cf.new(22, 7)
test.call("[1;5,2] * [3;7]", [NG.new(b, b1, b2), R2cf.new(286, 77)])

var c = NG8.new(0, 1, -1, 0, 0, 0, 0, 1)
var c1 = R2cf.new(13, 11)
var c2 = R2cf.new(22, 7)
test.call("[1;5,2] - [3;7]", [NG.new(c, c1, c2), R2cf.new(-151, 77)])

var d = NG8.new(0, 1, 0, 0, 0, 0, 1, 0)
var d1 = R2cf.new(22 * 22, 7 * 7)
var d2 = R2cf.new(22,7)
test.call("Divide [] by [3;7]", [NG.new(d, d1, d2)])

var na = NG8.new(0, 1, 1, 0, 0, 0, 0, 1)
var a1 = R2cf.new(2, 7)
var a2 = R2cf.new(13, 11)
var aa = NG.new(na, a1, a2)
var nb = NG8.new(0, 1, -1, 0, 0, 0, 0, 1)
var b3 = R2cf.new(2, 7)
var b4 = R2cf.new(13, 11)
var bb = NG.new(nb, b3, b4)
var nc = NG8.new(1, 0, 0, 0, 0, 0, 0, 1)
var desc = "([0;3,2] + [1;5,2]) * ([0;3,2] - [1;5,2])"
test.call(desc, [NG.new(nc, aa, bb), R2cf.new(-7797, 5929)])
