package main

import (
    "fmt"
    "log"
    "math"
    "sort"
    "strings"
)

const (
    algo          = 2
    maxAllFactors = 100000
)

func iabs(i int) int {
    if i < 0 {
        return -i
    }
    return i
}

type term struct{ coef, exp int }

func (t term) mul(t2 term) term {
    return term{t.coef * t2.coef, t.exp + t2.exp}
}

func (t term) add(t2 term) term {
    if t.exp != t2.exp {
        log.Fatal("exponents unequal in term.add method")
    }
    return term{t.coef + t2.coef, t.exp}
}

func (t term) negate() term { return term{-t.coef, t.exp} }

func (t term) String() string {
    switch {
    case t.coef == 0:
        return "0"
    case t.exp == 0:
        return fmt.Sprintf("%d", t.coef)
    case t.coef == 1:
        if t.exp == 1 {
            return "x"
        } else {
            return fmt.Sprintf("x^%d", t.exp)
        }
    case t.exp == 1:
        return fmt.Sprintf("%dx", t.coef)
    }
    return fmt.Sprintf("%dx^%d", t.coef, t.exp)
}

type poly struct{ terms []term }

// pass coef, exp in pairs as parameters
func newPoly(values ...int) poly {
    le := len(values)
    if le == 0 {
        return poly{[]term{term{0, 0}}}
    }
    if le%2 != 0 {
        log.Fatalf("odd number of parameters (%d) passed to newPoly function", le)
    }
    var terms []term
    for i := 0; i < le; i += 2 {
        terms = append(terms, term{values[i], values[i+1]})
    }
    p := poly{terms}.tidy()
    return p
}

func (p poly) hasCoefAbs(coef int) bool {
    for _, t := range p.terms {
        if iabs(t.coef) == coef {
            return true
        }
    }
    return false
}

func (p poly) add(p2 poly) poly {
    p3 := newPoly()
    le, le2 := len(p.terms), len(p2.terms)
    for le > 0 || le2 > 0 {
        if le == 0 {
            p3.terms = append(p3.terms, p2.terms[le2-1])
            le2--
        } else if le2 == 0 {
            p3.terms = append(p3.terms, p.terms[le-1])
            le--
        } else {
            t := p.terms[le-1]
            t2 := p2.terms[le2-1]
            if t.exp == t2.exp {
                t3 := t.add(t2)
                if t3.coef != 0 {
                    p3.terms = append(p3.terms, t3)
                }
                le--
                le2--
            } else if t.exp < t2.exp {
                p3.terms = append(p3.terms, t)
                le--
            } else {
                p3.terms = append(p3.terms, t2)
                le2--
            }
        }
    }
    return p3.tidy()
}

func (p poly) addTerm(t term) poly {
    q := newPoly()
    added := false
    for i := 0; i < len(p.terms); i++ {
        ct := p.terms[i]
        if ct.exp == t.exp {
            added = true
            if ct.coef+t.coef != 0 {
                q.terms = append(q.terms, ct.add(t))
            }
        } else {
            q.terms = append(q.terms, ct)
        }
    }
    if !added {
        q.terms = append(q.terms, t)
    }
    return q.tidy()
}

func (p poly) mulTerm(t term) poly {
    q := newPoly()
    for i := 0; i < len(p.terms); i++ {
        ct := p.terms[i]
        q.terms = append(q.terms, ct.mul(t))
    }
    return q.tidy()
}

func (p poly) div(v poly) poly {
    q := newPoly()
    lcv := v.leadingCoef()
    dv := v.degree()
    for p.degree() >= v.degree() {
        lcp := p.leadingCoef()
        s := lcp / lcv
        t := term{s, p.degree() - dv}
        q = q.addTerm(t)
        p = p.add(v.mulTerm(t.negate()))
    }
    return q.tidy()
}

func (p poly) leadingCoef() int {
    return p.terms[0].coef
}

func (p poly) degree() int {
    return p.terms[0].exp
}

func (p poly) String() string {
    var sb strings.Builder
    first := true
    for _, t := range p.terms {
        if first {
            sb.WriteString(t.String())
            first = false
        } else {
            sb.WriteString(" ")
            if t.coef > 0 {
                sb.WriteString("+ ")
                sb.WriteString(t.String())
            } else {
                sb.WriteString("- ")
                sb.WriteString(t.negate().String())
            }
        }
    }
    return sb.String()
}

// in place descending sort by term.exp
func (p poly) sortTerms() {
    sort.Slice(p.terms, func(i, j int) bool {
        return p.terms[i].exp > p.terms[j].exp
    })
}

// sort terms and remove any unnecesary zero terms
func (p poly) tidy() poly {
    p.sortTerms()
    if p.degree() == 0 {
        return p
    }
    for i := len(p.terms) - 1; i >= 0; i-- {
        if p.terms[i].coef == 0 {
            copy(p.terms[i:], p.terms[i+1:])
            p.terms[len(p.terms)-1] = term{0, 0}
            p.terms = p.terms[:len(p.terms)-1]
        }
    }
    if len(p.terms) == 0 {
        p.terms = append(p.terms, term{0, 0})
    }
    return p
}

func getDivisors(n int) []int {
    var divs []int
    sqrt := int(math.Sqrt(float64(n)))
    for i := 1; i <= sqrt; i++ {
        if n%i == 0 {
            divs = append(divs, i)
            d := n / i
            if d != i && d != n {
                divs = append(divs, d)
            }
        }
    }
    return divs
}

var (
    computed   = make(map[int]poly)
    allFactors = make(map[int]map[int]int)
)

func init() {
    f := map[int]int{2: 1}
    allFactors[2] = f
}

func getFactors(n int) map[int]int {
    if f, ok := allFactors[n]; ok {
        return f
    }
    factors := make(map[int]int)
    if n%2 == 0 {
        factorsDivTwo := getFactors(n / 2)
        for k, v := range factorsDivTwo {
            factors[k] = v
        }
        factors[2]++
        if n < maxAllFactors {
            allFactors[n] = factors
        }
        return factors
    }
    prime := true
    sqrt := int(math.Sqrt(float64(n)))
    for i := 3; i <= sqrt; i += 2 {
        if n%i == 0 {
            prime = false
            for k, v := range getFactors(n / i) {
                factors[k] = v
            }
            factors[i]++
            if n < maxAllFactors {
                allFactors[n] = factors
            }
            return factors
        }
    }
    if prime {
        factors[n] = 1
        if n < maxAllFactors {
            allFactors[n] = factors
        }
    }
    return factors
}

func cycloPoly(n int) poly {
    if p, ok := computed[n]; ok {
        return p
    }
    if n == 1 {
        // polynomial: x - 1
        p := newPoly(1, 1, -1, 0)
        computed[1] = p
        return p
    }
    factors := getFactors(n)
    cyclo := newPoly()
    if _, ok := factors[n]; ok {
        // n is prime
        for i := 0; i < n; i++ {
            cyclo.terms = append(cyclo.terms, term{1, i})
        }
    } else if len(factors) == 2 && factors[2] == 1 && factors[n/2] == 1 {
        // n == 2p
        prime := n / 2
        coef := -1
        for i := 0; i < prime; i++ {
            coef *= -1
            cyclo.terms = append(cyclo.terms, term{coef, i})
        }
    } else if len(factors) == 1 {
        if h, ok := factors[2]; ok {
            // n == 2^h
            cyclo.terms = append(cyclo.terms, term{1, 1 << (h - 1)}, term{1, 0})
        } else if _, ok := factors[n]; !ok {
            // n == p ^ k
            p := 0
            for prime := range factors {
                p = prime
            }
            k := factors[p]
            for i := 0; i < p; i++ {
                pk := int(math.Pow(float64(p), float64(k-1)))
                cyclo.terms = append(cyclo.terms, term{1, i * pk})
            }
        }
    } else if len(factors) == 2 && factors[2] != 0 {
        // n = 2^h * p^k
        p := 0
        for prime := range factors {
            if prime != 2 {
                p = prime
            }
        }
        coef := -1
        twoExp := 1 << (factors[2] - 1)
        k := factors[p]
        for i := 0; i < p; i++ {
            coef *= -1
            pk := int(math.Pow(float64(p), float64(k-1)))
            cyclo.terms = append(cyclo.terms, term{coef, i * twoExp * pk})
        }
    } else if factors[2] != 0 && ((n/2)%2 == 1) && (n/2) > 1 {
        //  CP(2m)[x] == CP(-m)[x], n odd integer > 1
        cycloDiv2 := cycloPoly(n / 2)
        for _, t := range cycloDiv2.terms {
            t2 := t
            if t.exp%2 != 0 {
                t2 = t.negate()
            }
            cyclo.terms = append(cyclo.terms, t2)
        }
    } else if algo == 0 {
        // slow - uses basic definition
        divs := getDivisors(n)
        // polynomial: x^n - 1
        cyclo = newPoly(1, n, -1, 0)
        for _, i := range divs {
            p := cycloPoly(i)
            cyclo = cyclo.div(p)
        }
    } else if algo == 1 {
        //  faster - remove max divisor (and all divisors of max divisor)
        //  only one divide for all divisors of max divisor
        divs := getDivisors(n)
        maxDiv := math.MinInt32
        for _, d := range divs {
            if d > maxDiv {
                maxDiv = d
            }
        }
        var divsExceptMax []int
        for _, d := range divs {
            if maxDiv%d != 0 {
                divsExceptMax = append(divsExceptMax, d)
            }
        }
        // polynomial:  ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
        cyclo = newPoly(1, n, -1, 0)
        cyclo = cyclo.div(newPoly(1, maxDiv, -1, 0))
        for _, i := range divsExceptMax {
            p := cycloPoly(i)
            cyclo = cyclo.div(p)
        }
    } else if algo == 2 {
        //  fastest
        //  let p, q be primes such that p does not divide n, and q divides n
        //  then CP(np)[x] = CP(n)[x^p] / CP(n)[x]
        m := 1
        cyclo = cycloPoly(m)
        var primes []int
        for prime := range factors {
            primes = append(primes, prime)
        }
        sort.Ints(primes)
        for _, prime := range primes {
            //  CP(m)[x]
            cycloM := cyclo
            //  compute CP(m)[x^p]
            var terms []term
            for _, t := range cycloM.terms {
                terms = append(terms, term{t.coef, t.exp * prime})
            }
            cyclo = newPoly()
            cyclo.terms = append(cyclo.terms, terms...)
            cyclo = cyclo.tidy()
            cyclo = cyclo.div(cycloM)
            m *= prime
        }
        //  now, m is the largest square free divisor of n
        s := n / m
        //  Compute CP(n)[x] = CP(m)[x^s]
        var terms []term
        for _, t := range cyclo.terms {
            terms = append(terms, term{t.coef, t.exp * s})
        }
        cyclo = newPoly()
        cyclo.terms = append(cyclo.terms, terms...)
    } else {
        log.Fatal("invalid algorithm")
    }
    cyclo = cyclo.tidy()
    computed[n] = cyclo
    return cyclo
}

func main() {
    fmt.Println("Task 1:  cyclotomic polynomials for n <= 30:")
    for i := 1; i <= 30; i++ {
        p := cycloPoly(i)
        fmt.Printf("CP[%2d] = %s\n", i, p)
    }

    fmt.Println("\nTask 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:")
    n := 0
    for i := 1; i <= 10; i++ {
        for {
            n++
            cyclo := cycloPoly(n)
            if cyclo.hasCoefAbs(i) {
                fmt.Printf("CP[%d] has coefficient with magnitude = %d\n", n, i)
                n--
                break
            }
        }
    }
}
