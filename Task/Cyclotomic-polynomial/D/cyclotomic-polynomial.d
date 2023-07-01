import std.algorithm;
import std.exception;
import std.format;
import std.functional;
import std.math;
import std.range;
import std.stdio;

immutable MAX_ALL_FACTORS = 100_000;
immutable ALGORITHM = 2;

//Note: Cyclotomic Polynomials have small coefficients.  Not appropriate for general polynomial usage.

struct Term {
    private long m_coefficient;
    private long m_exponent;

    public this(long c, long e) {
        m_coefficient = c;
        m_exponent = e;
    }

    public long coefficient() const {
        return m_coefficient;
    }

    public long exponent() const {
        return m_exponent;
    }

    public Term opUnary(string op)() const {
        static if (op == "-") {
            return Term(-m_coefficient, m_exponent);
        } else {
            assert(false, "Not implemented");
        }
    }

    public Term opBinary(string op)(Term term) const {
        static if (op == "+") {
            if (exponent() != term.exponent()) {
                assert(false, "Error 102: Exponents not equals.");
            }
            return Term(coefficient() + term.coefficient(), exponent());
        } else if (op == "*") {
            return Term(coefficient() * term.coefficient(), exponent() + term.exponent());
        } else {
            assert(false, "Not implemented: " ~ op);
        }
    }

    public void toString(scope void delegate(const(char)[]) sink) const {
        auto spec = singleSpec("%s");
        if (m_coefficient == 0) {
            sink("0");
        } else if (m_exponent == 0) {
            formatValue(sink, m_coefficient, spec);
        } else if (m_coefficient == 1) {
            if (m_exponent == 1) {
                sink("x");
            } else {
                sink("x^");
                formatValue(sink, m_exponent, spec);
            }
        } else if (m_coefficient == -1) {
            if (m_exponent == 1) {
                sink("-x");
            } else {
                sink("-x^");
                formatValue(sink, m_exponent, spec);
            }
        } else if (m_exponent == 1) {
            formatValue(sink, m_coefficient, spec);
            sink("x");
        } else {
            formatValue(sink, m_coefficient, spec);
            sink("x^");
            formatValue(sink, m_exponent, spec);
        }
    }
}

struct Polynomial {
    private Term[] terms;

    public this(const Term[] ts...) {
        terms = ts.dup;
        terms.sort!"b.exponent < a.exponent";
    }

    bool hasCoefficientAbs(int coeff) const {
        foreach (term; terms) {
            if (abs(term.coefficient) == coeff) {
                return true;
            }
        }
        return false;
    }

    public long leadingCoefficient() const {
        return terms[0].coefficient();
    }

    public long degree() const {
        if (terms.empty) {
            return -1;
        }
        return terms[0].exponent();
    }

    public Polynomial opBinary(string op)(Term term) const {
        static if (op == "+") {
            Term[] newTerms;
            auto added = false;
            foreach (currentTerm; terms) {
                if (currentTerm.exponent() == term.exponent()) {
                    added = true;
                    if (currentTerm.coefficient() + term.coefficient() != 0) {
                        newTerms ~= currentTerm + term;
                    }
                } else {
                    newTerms ~= currentTerm;
                }
            }
            if (!added) {
                newTerms ~= term;
            }
            return Polynomial(newTerms);
        } else if (op == "*") {
            Term[] newTerms;
            foreach (currentTerm; terms) {
                newTerms ~= currentTerm * term;
            }
            return Polynomial(newTerms);
        } else {
            assert(false, "Not implemented: " ~ op);
        }
    }

    public Polynomial opBinary(string op)(Polynomial rhs) const {
        static if (op == "+") {
            Term[] newTerms;
            auto thisCount = terms.length;
            auto polyCount = rhs.terms.length;
            while (thisCount > 0 || polyCount > 0) {
                if (thisCount == 0) {
                    newTerms ~= rhs.terms[polyCount - 1];
                    polyCount--;
                } else if (polyCount == 0) {
                    newTerms ~= terms[thisCount - 1];
                    thisCount--;
                } else {
                    auto thisTerm = terms[thisCount - 1];
                    auto polyTerm = rhs.terms[polyCount - 1];
                    if (thisTerm.exponent() == polyTerm.exponent()) {
                        auto t = thisTerm + polyTerm;
                        if (t.coefficient() != 0) {
                            newTerms ~= t;
                        }
                        thisCount--;
                        polyCount--;
                    } else if (thisTerm.exponent() < polyTerm.exponent()) {
                        newTerms ~= thisTerm;
                        thisCount--;
                    } else {
                        newTerms ~= polyTerm;
                        polyCount--;
                    }
                }
            }
            return Polynomial(newTerms);
        } else if (op == "/") {
            Polynomial q;
            auto r = Polynomial(terms);
            auto lcv = rhs.leadingCoefficient();
            auto dv = rhs.degree();
            while (r.degree() >= rhs.degree()) {
                auto lcr = r.leadingCoefficient();
                auto s = lcr / lcv;
                auto term = Term(s, r.degree() - dv);
                q = q + term;
                r = r + rhs * -term;
            }
            return q;
        } else {
            assert(false, "Not implemented: " ~ op);
        }
    }

    public int opApply(int delegate(Term) dg) const {
        foreach (term; terms) {
            auto rv = dg(term);
            if (rv != 0) {
                return rv;
            }
        }
        return 0;
    }

    public void toString(scope void delegate(const(char)[]) sink) const {
        auto spec = singleSpec("%s");
        if (!terms.empty) {
            formatValue(sink, terms[0], spec);
            foreach (t; terms[1..$]) {
                if (t.coefficient > 0) {
                    sink(" + ");
                    formatValue(sink, t, spec);
                } else {
                    sink(" - ");
                    formatValue(sink, -t, spec);
                }
            }
        }
    }
}

void putAll(K, V)(ref V[K] a, V[K] b) {
    foreach (k, v; b) {
        a[k] = v;
    }
}

void merge(K, V, F)(ref V[K] a, K k, V v, F f) {
    if (k in a) {
        a[k] = f(a[k], v);
    } else {
        a[k] = v;
    }
}

int sum(int a, int b) {
    return a + b;
}

int[int] getFactorsImpl(int number) {
    int[int] factors;
    if (number % 2 == 0) {
        if (number > 2) {
            auto factorsDivTwo = memoize!getFactorsImpl(number / 2);
            factors.putAll(factorsDivTwo);
        }
        factors.merge(2, 1, &sum);
        return factors;
    }
    auto root = sqrt(cast(real) number);
    auto i = 3;
    while (i <= root) {
        if (number % i == 0) {
            factors.putAll(memoize!getFactorsImpl(number / i));
            factors.merge(i, 1, &sum);
            return factors;
        }
        i += 2;
    }
    factors[number] = 1;
    return factors;
}
alias getFactors = memoize!getFactorsImpl;

int[] getDivisors(int number) {
    int[] divisors;
    auto root = cast(int)sqrt(cast(real) number);
    foreach (i; 1..root) {
        if (number % i == 0) {
            divisors ~= i;
        }
        auto div = number / i;
        if (div != i && div != number) {
            divisors ~= div;
        }
    }
    return divisors;
}

Polynomial cyclotomicPolynomialImpl(int n) {
    if (n == 1) {
        //  Polynomial:  x - 1
        return Polynomial(Term(1, 1), Term(-1, 0));
    }
    auto factors = getFactors(n);
    if (n in factors) {
        // n prime
        Term[] terms;
        foreach (i; 0..n) {
            terms ~= Term(1, i);
        }
        return Polynomial(terms);
    } else if (factors.length == 2 && 2 in factors && factors[2] == 1 && (n / 2) in factors && factors[n / 2] == 1) {
        //  n = 2p
        auto prime = n / 2;
        Term[] terms;
        auto coeff = -1;
        foreach (i; 0..prime) {
            coeff *= -1;
            terms ~= Term(coeff, i);
        }
        return Polynomial(terms);
    } else if (factors.length == 1 && 2 in factors) {
        //  n = 2^h
        auto h = factors[2];
        Term[] terms;
        terms ~= Term(1, 2 ^^ (h - 1));
        terms ~= Term(1, 0);
        return Polynomial(terms);
    } else if (factors.length == 1 && n !in factors) {
        // n = p^k
        auto p = 0;
        auto k = 0;
        foreach (prime, v; factors) {
            if (prime > p) {
                p = prime;
                k = v;
            }
        }
        Term[] terms;
        foreach (i; 0..p) {
            terms ~= Term(1, (i * p) ^^ (k - 1));
        }
        return Polynomial(terms);
    } else if (factors.length == 2 && 2 in factors) {
        // n = 2^h * p^k
        auto p = 0;
        auto k = 0;
        foreach (prime, v; factors) {
            if (prime != 2 && prime > p) {
                p = prime;
                k = v;
            }
        }
        Term[] terms;
        auto coeff = -1;
        auto twoExp = 2 ^^ (factors[2] - 1);
        foreach (i; 0..p) {
            coeff *= -1;
            auto exponent = i * twoExp * p ^^ (k - 1);
            terms ~= Term(coeff, exponent);
        }
        return Polynomial(terms);
    } else if (2 in factors && n / 2 % 2 == 1 && n / 2 > 1) {
        //  CP(2m)[x] = CP(-m)[x], n odd integer > 1
        auto cycloDiv2 = memoize!cyclotomicPolynomialImpl(n / 2);
        Term[] terms;
        foreach (term; cycloDiv2) {
            if (term.exponent() % 2 == 0) {
                terms ~= term;
            } else {
                terms ~= -term;
            }
        }
        return Polynomial(terms);
    }

    if (ALGORITHM == 0) {
        //  Slow - uses basic definition.
        auto divisors = getDivisors(n);
        //  Polynomial:  ( x^n - 1 )
        auto cyclo = Polynomial(Term(1, n), Term(-1, 0));
        foreach (i; divisors) {
            auto p = memoize!cyclotomicPolynomialImpl(i);
            cyclo = cyclo / p;
        }
        return cyclo;
    }
    if (ALGORITHM == 1) {
        //  Faster.  Remove Max divisor (and all divisors of max divisor) - only one divide for all divisors of Max Divisor
        auto divisors = getDivisors(n);
        auto maxDivisor = int.min;
        foreach (div; divisors) {
            maxDivisor = max(maxDivisor, div);
        }
        int[] divisorsExceptMax;
        foreach (div; divisors) {
            if (maxDivisor % div != 0) {
                divisorsExceptMax ~= div;
            }
        }

        //  Polynomial:  ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
        auto cyclo = Polynomial(Term(1, n), Term(-1, 0)) / Polynomial(Term(1, maxDivisor), Term(-1, 0));
        foreach (i; divisorsExceptMax) {
            auto p = memoize!cyclotomicPolynomialImpl(i);
            cyclo = cyclo / p;
        }
        return cyclo;
    }
    if (ALGORITHM == 2) {
        //  Fastest
        //  Let p ; q be primes such that p does not divide n, and q q divides n.
        //  Then CP(np)[x] = CP(n)[x^p] / CP(n)[x]
        auto m = 1;
        auto cyclo = memoize!cyclotomicPolynomialImpl(m);
        auto primes = factors.keys;
        primes.sort;
        foreach (prime; primes) {
            //  CP(m)[x]
            auto cycloM = cyclo;
            //  Compute CP(m)[x^p].
            Term[] terms;
            foreach (term; cycloM) {
                terms ~= Term(term.coefficient(), term.exponent() * prime);
            }
            cyclo = Polynomial(terms) / cycloM;
            m *= prime;
        }
        //  Now, m is the largest square free divisor of n
        auto s = n / m;
        //  Compute CP(n)[x] = CP(m)[x^s]
        Term[] terms;
        foreach (term; cyclo) {
            terms ~= Term(term.coefficient(), term.exponent() * s);
        }
        return Polynomial(terms);
    }
    assert(false, "Error 103: Invalid algorithm");
}
alias cyclotomicPolynomial = memoize!cyclotomicPolynomialImpl;

void main() {
    writeln("Task 1:  cyclotomic polynomials for n <= 30:");
   foreach (i; 1 .. 31) {
        auto p = cyclotomicPolynomial(i);
        writefln("CP[%d] = %s", i, p);
   }
    writeln;

    writeln("Task 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:");
    auto n = 0;
    foreach (i; 1 .. 11) {
         while (true) {
            n++;
            auto cyclo = cyclotomicPolynomial(n);
            if (cyclo.hasCoefficientAbs(i)) {
                writefln("CP[%d] has coefficient with magnitude = %d", n, i);
                n--;
                break;
            }
         }
    }
}
