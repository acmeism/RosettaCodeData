import "./rat" for Rat

class Gene {
    coef(n) {}
}

class Term {
    construct new(gene) {
        _gene = gene
        _cache = []
    }

    gene { _gene }

    [n] {
        if (n < 0) return Rat.zero
        if (n >= _cache.count) {
            for (i in _cache.count..n) _cache.add(gene.coef(i))
        }
        return _cache[n]
    }
}

class FormalPS {
    static DISP_TERM { 12 }
    static X_VAR { "x" }

    construct new() {
        _term = null
    }

    construct new(term) {
        _term = term
    }

    term { _term }

    static fromPolynomial(polynomial) {
        class PolyGene is Gene {
            construct new (polynomial) { _polynomial = polynomial }
            coef(n) { (n < 0 || n >= _polynomial.count) ? Rat.zero : _polynomial[n] }
        }
        return FormalPS.new(Term.new(PolyGene.new(polynomial)))
    }

    copyFrom(other) { _term = other.term }

    inverseCoef(n) {
        var res = List.filled(n+1, null)
        res[0] = _term[0].inverse
        if (n > 0) {
            for (i in 1..n) {
                res[i] = Rat.zero
                for (j in 0...i) res[i] = res[i] + _term[i - j] * res[j]
                res[i] = -res[0] * res[i]
            }
        }
        return res[n]
    }

    +(other) {
        class AddGene is Gene {
            construct new(fps, other) {
                _fps = fps
                _other = other
            }
            coef(n) { _fps.term[n] + _other.term[n] }
        }
        return FormalPS.new(Term.new(AddGene.new(this, other)))
    }

    -(other) {
        class SubGene is Gene {
            construct new(fps, other) {
                _fps = fps
                _other = other
            }
            coef(n) { _fps.term[n] - _other.term[n] }
        }
        return FormalPS.new(Term.new(SubGene.new(this, other)))
    }

    *(other) {
        class MulGene is Gene {
            construct new(fps, other) {
                _fps = fps
                _other = other
            }
            coef(n) {
                var res = Rat.zero
                for (i in 0..n) res = res + _fps.term[i] * _other.term[n-i]
                return res
            }
        }
        return FormalPS.new(Term.new(MulGene.new(this, other)))
    }

    /(other) {
        class DivGene is Gene {
            construct new(fps, other) {
                _fps = fps
                _other = other
            }
            coef(n) {
                var res = Rat.zero
                for (i in 0..n) res = res + _fps.term[i] * _other.inverseCoef(n-i)
                return res
            }
        }
        return FormalPS.new(Term.new(DivGene.new(this, other)))
    }

    diff() {
        class DiffGene is Gene {
            construct new(fps) { _fps = fps }
            coef(n) { _fps.term[n+1] * Rat.new(n+1) }
        }
        return FormalPS.new(Term.new(DiffGene.new(this)))
    }

    intg() {
        class IntgGene is Gene {
            construct new(fps) { _fps= fps }
            coef(n) { (n == 0) ? Rat.zero : _fps.term[n-1] * Rat.new(1, n) }
        }
        return FormalPS.new(Term.new(IntgGene.new(this)))
    }

    toString_(dpTerm) {
        var sb = ""
        var c = _term[0]
        Rat.showAsInt = true
        var supers = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "¹⁰", "¹¹"]
        if (c != Rat.zero) sb = sb + c.toString
        for (i in 1...dpTerm) {
            c = term[i]
            if (c != Rat.zero) {
                if (c > Rat.zero && sb.count > 0) sb = sb + " + "
                var xvar = FormalPS.X_VAR
                sb = sb +
                     ((c == Rat.one) ? xvar :
                      (c == Rat.minusOne) ? " - %(xvar)" :
                      (c.num < 0) ? " - %(-c)%(xvar)" : "%(c)%(xvar)")
                if (i > 1) sb = sb + "%(supers[i])"
            }
        }
        if (sb.count == 0) sb = "0"
        sb = sb + " + ..."
        return sb
    }

    toString { toString_(FormalPS.DISP_TERM) }
}

var cos = FormalPS.new()
var sin = cos.intg()
var tan = sin/cos
cos.copyFrom(FormalPS.fromPolynomial([Rat.one]) - sin.intg())
System.print("sin(x)  = %(sin)")
System.print("cos(x)  = %(cos)")
System.print("tan(x)  = %(tan)")
System.print("sin'(x) = %(sin.diff())")
var exp = FormalPS.new()
exp.copyFrom(FormalPS.fromPolynomial([Rat.one]) + exp.intg())
System.print("exp(x)  = %(exp)")
