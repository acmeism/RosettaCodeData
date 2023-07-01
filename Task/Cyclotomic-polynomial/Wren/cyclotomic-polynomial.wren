import "/iterate" for Stepped
import "/sort" for Sort
import "/math" for Int, Nums
import "/fmt" for Fmt

var algo = 2
var maxAllFactors = 1e5

class Term {
    construct new(coef, exp) {
        _coef = coef
        _exp = exp
    }

    coef { _coef }
    exp  { _exp }

    *(t) { Term.new(_coef * t.coef, _exp + t.exp) }

    +(t) {
        if (_exp != t.exp) Fiber.abort("Exponents unequal in term '+' method.")
        return Term.new(_coef + t.coef, _exp)
    }

    - { Term.new(-_coef, _exp) }

    toString {
        if (_coef == 0) return "0"
        if (_exp == 0)  return _coef.toString
        if (_coef == 1) return (_exp == 1) ? "x" : "x^%(_exp)"
        if (_exp == 1)  return "%(_coef)x"
        return "%(_coef)x^%(_exp)"
    }
}

class Poly {
    // pass coef, exp in pairs as parameters
    construct new(values) {
        var le = values.count
        if (le == 0) {
            _terms = [Term.new(0, 0)]
        } else {
            if (le%2 != 0) Fiber.abort("Odd number of parameters(%(le)) passed to Poly constructor.")
            _terms = []
            for (i in Stepped.new(0...le, 2)) _terms.add(Term.new(values[i], values[i+1]))
            tidy()
        }
    }

    terms { _terms }

    hasCoefAbs(coef) { _terms.any { |t| t.coef.abs == coef } }

    +(p2) {
        var p3 = Poly.new([])
        var le = _terms.count
        var le2 = p2.terms.count
        while (le > 0 || le2 > 0) {
            if (le == 0) {
                p3.terms.add(p2.terms[le2-1])
                le2 = le2 - 1
            } else if (le2 == 0) {
                p3.terms.add(_terms[le-1])
                le = le - 1
            } else {
                var t = _terms[le-1]
                var t2 = p2.terms[le2-1]
                if (t.exp == t2.exp) {
                    var t3 = t + t2
                    if (t3.coef != 0) p3.terms.add(t3)
                    le = le - 1
                    le2 = le2 - 1
                } else if (t.exp < t2.exp) {
                    p3.terms.add(t)
                    le = le - 1
                } else {
                    p3.terms.add(t2)
                    le2 = le2 - 1
                }
            }
        }
        p3.tidy()
        return p3
    }

    addTerm(t) {
        var q = Poly.new([])
        var added = false
        for (i in 0..._terms.count) {
            var ct = _terms[i]
            if (ct.exp == t.exp) {
                added = true
                if (ct.coef + t.coef != 0) q.terms.add(ct + t)
            } else {
                q.terms.add(ct)
            }
        }
        if (!added) q.terms.add(t)
        q.tidy()
        return q
    }

    mulTerm(t) {
        var q = Poly.new([])
        for (i in 0..._terms.count) {
            var ct = _terms[i]
            q.terms.add(ct * t)
        }
        q.tidy()
        return q
    }

    /(v) {
        var p = this
        var q = Poly.new([])
        var lcv = v.leadingCoef
        var dv = v.degree
        while (p.degree >= v.degree) {
            var lcp = p.leadingCoef
            var s = (lcp/lcv).truncate
            var t = Term.new(s, p.degree - dv)
            q = q.addTerm(t)
            p = p + v.mulTerm(-t)
        }
        q.tidy()
        return q
    }

    leadingCoef { _terms[0].coef }

    degree { _terms[0].exp }

    toString {
        var sb = ""
        var first = true
        for (t in _terms) {
            if (first) {
                sb = sb + t.toString
                first = false
            } else {
                sb = sb + " "
                if (t.coef > 0) {
                    sb = sb + "+ "
                    sb = sb + t.toString
                } else {
                    sb = sb + "- "
                    sb = sb + (-t).toString
                }
            }
        }
        return sb
    }

    // in place descending sort by term.exp
    sortTerms() {
        var cmp  = Fn.new { |t1, t2| (t2.exp - t1.exp).sign }
        Sort.quick(_terms, 0, _terms.count-1, cmp)
    }

    // sort terms and remove any unnecesary zero terms
    tidy() {
        sortTerms()
        if (degree > 0) {
            for (i in _terms.count-1..0) {
                if (_terms[i].coef == 0) _terms.removeAt(i)
            }
            if (_terms.count == 0) _terms.add(Term.new(0, 0))
        }
    }
}

var computed = {}
var allFactors = {2: {2: 1}}

var getFactors // recursive function
getFactors = Fn.new { |n|
    var f = allFactors[n]
    if (f) return f
    var factors = {}
    if (n%2 == 0) {
        var factorsDivTwo = getFactors.call(n/2)
        for (me in factorsDivTwo) factors[me.key] = me.value
        factors[2] = factors[2] ? factors[2] + 1 : 1
        if (n < maxAllFactors) allFactors[n] = factors
        return factors
    }
    var prime = true
    var sqrt = n.sqrt.floor
    var i = 3
    while (i <= sqrt){
        if (n%i == 0) {
            prime = false
            for (me in getFactors.call(n/i)) factors[me.key] = me.value
            factors[i] = factors[i] ? factors[i] + 1 : 1
            if (n < maxAllFactors) allFactors[n] = factors
            return factors
        }
        i = i + 2
    }
    if (prime) {
        factors[n] = 1
        if (n < maxAllFactors) allFactors[n] = factors
    }
    return factors
}

var cycloPoly // recursive function
cycloPoly = Fn.new { |n|
    var p = computed[n]
    if (p) return p
    if (n == 1) {
        // polynomialL x - 1
        p = Poly.new([1, 1, -1, 0])
        computed[1] = p
        return p
    }
    var factors = getFactors.call(n)
    var cyclo = Poly.new([])
    if (factors[n]) {
        // n is prime
        for (i in 0...n) cyclo.terms.add(Term.new(1, i))
    } else if (factors.count == 2 && factors[2] == 1 && factors[n/2] == 1) {
        // n == 2p
        var prime = n / 2
        var coef = -1
        for (i in 0...prime) {
            coef = coef * (-1)
            cyclo.terms.add(Term.new(coef, i))
        }
    } else if (factors.count == 1) {
        var h = factors[2]
        if (h) { // n == 2^h
            cyclo.terms.addAll([Term.new(1, 1 << (h-1)), Term.new(1, 0)])
        } else if (!factors[n]) {
            // n == p ^ k
           var p = 0
           for (prime in factors.keys) p = prime
           var k = factors[p]
           for (i in 0...p) {
                var pk = p.pow(k-1).floor
                cyclo.terms.add(Term.new(1, i * pk))
           }
        }
    } else if (factors.count == 2 && factors[2]) {
        // n = 2^h * p^k
        var p = 0
        for (prime in factors.keys) if (prime != 2) p = prime
        var coef = -1
        var twoExp = 1 << (factors[2] - 1)
        var k = factors[p]
        for (i in 0...p) {
            coef = coef * (-1)
            var pk = p.pow(k-1).floor
            cyclo.terms.add(Term.new(coef, i * twoExp * pk))
        }
    } else if (factors[2] && (n/2) % 2 == 1 && (n/2) > 1) {
        //  CP(2m)[x] == CP(-m)[x], n odd integer > 1
        var cycloDiv2 = cycloPoly.call(n/2)
        for (t in cycloDiv2.terms) {
            var t2 = t
            if (t.exp % 2 != 0) t2 = -t
            cyclo.terms.add(t2)
        }
    } else if (algo == 0) {
        // slow - uses basic definition
        var divs = Int.properDivisors(n)
        // polynomial: x^n - 1
        var cyclo = Poly.new([1, n, -1, 0])
        for (i in divs) {
            var p = cycloPoly.call(i)
            cyclo = cyclo / p
        }
    } else if (algo == 1) {
        //  faster - remove max divisor (and all divisors of max divisor)
        //  only one divide for all divisors of max divisor
        var divs = Int.properDivisors(n)
        var maxDiv = Nums.max(divs)
        var divsExceptMax = divs.where { |d| maxDiv % d != 0 }.toList
        // polynomial:  ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
        cyclo = Poly.new([1, n, -1, 0])
        cyclo = cyclo / Poly.new([1, maxDiv, -1, 0])
        for (i in divsExceptMax) {
            var p = cycloPoly.call(i)
            cyclo = cyclo / p
        }
    } else if (algo == 2) {
        //  fastest
        //  let p, q be primes such that p does not divide n, and q divides n
        //  then CP(np)[x] = CP(n)[x^p] / CP(n)[x]
        var m = 1
        cyclo = cycloPoly.call(m)
        var primes = []
        for (prime in factors.keys) primes.add(prime)
        Sort.quick(primes)
        for (prime in primes) {
            // CP(m)[x]
            var cycloM = cyclo
            // compute CP(m)[x^p]
            var terms = []
            for (t in cycloM.terms) terms.add(Term.new(t.coef, t.exp * prime))
            cyclo = Poly.new([])
            cyclo.terms.addAll(terms)
            cyclo.tidy()
            cyclo = cyclo / cycloM
            m = m * prime
        }
        //  now, m is the largest square free divisor of n
        var s = n / m
        //  Compute CP(n)[x] = CP(m)[x^s]
        var terms = []
        for (t in cyclo.terms) terms.add(Term.new(t.coef, t.exp * s))
        cyclo = Poly.new([])
        cyclo.terms.addAll(terms)
    } else {
        Fiber.abort("Invalid algorithm.")
    }
    cyclo.tidy()
    computed[n] = cyclo
    return cyclo
}

System.print("Task 1:  cyclotomic polynomials for n <= 30:")
for (i in 1..30) {
    var p = cycloPoly.call(i)
    Fmt.print("CP[$2d] = $s", i, p)
}

System.print("\nTask 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:")
var n = 0
for (i in 1..7) {
     while(true) {
        n = n + 1
        var cyclo = cycloPoly.call(n)
        if (cyclo.hasCoefAbs(i)) {
            Fmt.print("CP[$d] has coefficient with magnitude = $d", n, i)
            n = n - 1
            break
        }
    }
}
