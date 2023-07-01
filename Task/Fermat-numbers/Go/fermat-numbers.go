package main

import (
    "fmt"
    "github.com/jbarham/primegen"
    "math"
    "math/big"
    "math/rand"
    "sort"
    "time"
)

const (
    maxCurves = 10000
    maxRnd    = 1 << 31
    maxB1     = uint64(43 * 1e7)
    maxB2     = uint64(2 * 1e10)
)

var (
    zero  = big.NewInt(0)
    one   = big.NewInt(1)
    two   = big.NewInt(2)
    three = big.NewInt(3)
    four  = big.NewInt(4)
    five  = big.NewInt(5)
)

// Uses algorithm in Wikipedia article, including speed-up.
func pollardRho(n *big.Int) (*big.Int, error) {
    // g(x) = (x^2 + 1) mod n
    g := func(x, n *big.Int) *big.Int {
        x2 := new(big.Int)
        x2.Mul(x, x)
        x2.Add(x2, one)
        return x2.Mod(x2, n)
    }
    x, y, d := new(big.Int).Set(two), new(big.Int).Set(two), new(big.Int).Set(one)
    t, z := new(big.Int), new(big.Int).Set(one)
    count := 0
    for {
        x = g(x, n)
        y = g(g(y, n), n)
        t.Sub(x, y)
        t.Abs(t)
        t.Mod(t, n)
        z.Mul(z, t)
        count++
        if count == 100 {
            d.GCD(nil, nil, z, n)
            if d.Cmp(one) != 0 {
                break
            }
            z.Set(one)
            count = 0
        }
    }
    if d.Cmp(n) == 0 {
        return nil, fmt.Errorf("Pollard's rho failure")
    }
    return d, nil
}

// Gets all primes under 'n' - uses a Sieve of Atkin under the hood.
func getPrimes(n uint64) []uint64 {
    pg := primegen.New()
    var primes []uint64
    for {
        prime := pg.Next()
        if prime < n {
            primes = append(primes, prime)
        } else {
            break
        }
    }
    return primes
}

// Computes Stage 1 and Stage 2 bounds.
func computeBounds(n *big.Int) (uint64, uint64) {
    le := len(n.String())
    var b1, b2 uint64
    switch {
    case le <= 30:
        b1, b2 = 2000, 147396
    case le <= 40:
        b1, b2 = 11000, 1873422
    case le <= 50:
        b1, b2 = 50000, 12746592
    case le <= 60:
        b1, b2 = 250000, 128992510
    case le <= 70:
        b1, b2 = 1000000, 1045563762
    case le <= 80:
        b1, b2 = 3000000, 5706890290
    default:
        b1, b2 = maxB1, maxB2
    }
    return b1, b2
}

// Adds two specified P and Q points (in Montgomery form). Assumes R = P - Q.
func pointAdd(px, pz, qx, qz, rx, rz, n *big.Int) (*big.Int, *big.Int) {
    t := new(big.Int).Sub(px, pz)
    u := new(big.Int).Add(qx, qz)
    u.Mul(t, u)
    t.Add(px, pz)
    v := new(big.Int).Sub(qx, qz)
    v.Mul(t, v)
    upv := new(big.Int).Add(u, v)
    umv := new(big.Int).Sub(u, v)
    x := new(big.Int).Mul(upv, upv)
    x.Mul(x, rz)
    if x.Cmp(n) >= 0 {
        x.Mod(x, n)
    }
    z := new(big.Int).Mul(umv, umv)
    z.Mul(z, rx)
    if z.Cmp(n) >= 0 {
        z.Mod(z, n)
    }
    return x, z
}

// Doubles a point P (in Montgomery form).
func pointDouble(px, pz, n, a24 *big.Int) (*big.Int, *big.Int) {
    u2 := new(big.Int).Add(px, pz)
    u2.Mul(u2, u2)
    v2 := new(big.Int).Sub(px, pz)
    v2.Mul(v2, v2)
    t := new(big.Int).Sub(u2, v2)
    x := new(big.Int).Mul(u2, v2)
    if x.Cmp(n) >= 0 {
        x.Mod(x, n)
    }
    z := new(big.Int).Mul(a24, t)
    z.Add(v2, z)
    z.Mul(t, z)
    if z.Cmp(n) >= 0 {
        z.Mod(z, n)
    }
    return x, z
}

// Multiplies a specified point P (in Montgomery form) by a specified scalar.
func scalarMultiply(k, px, pz, n, a24 *big.Int) (*big.Int, *big.Int) {
    sk := fmt.Sprintf("%b", k)
    lk := len(sk)
    qx := new(big.Int).Set(px)
    qz := new(big.Int).Set(pz)
    rx, rz := pointDouble(px, pz, n, a24)
    for i := 1; i < lk; i++ {
        if sk[i] == '1' {
            qx, qz = pointAdd(rx, rz, qx, qz, px, pz, n)
            rx, rz = pointDouble(rx, rz, n, a24)

        } else {
            rx, rz = pointAdd(qx, qz, rx, rz, px, pz, n)
            qx, qz = pointDouble(qx, qz, n, a24)
        }
    }
    return qx, qz
}

// Lenstra's two-stage ECM algorithm.
func ecm(n *big.Int) (*big.Int, error) {
    if n.Cmp(one) == 0 || n.ProbablyPrime(10) {
        return n, nil
    }
    b1, b2 := computeBounds(n)
    dd := uint64(math.Sqrt(float64(b2)))
    beta := make([]*big.Int, dd+1)
    for i := 0; i < len(beta); i++ {
        beta[i] = new(big.Int)
    }
    s := make([]*big.Int, 2*dd+2)
    for i := 0; i < len(s); i++ {
        s[i] = new(big.Int)
    }

    // stage 1 and stage 2 precomputations
    curves := 0
    logB1 := math.Log(float64(b1))
    primes := getPrimes(b2)
    numPrimes := len(primes)
    idxB1 := sort.Search(len(primes), func(i int) bool { return primes[i] >= b1 })

    // compute a B1-powersmooth integer 'k'
    k := big.NewInt(1)
    for i := 0; i < idxB1; i++ {
        p := primes[i]
        bp := new(big.Int).SetUint64(p)
        t := uint64(logB1 / math.Log(float64(p)))
        bt := new(big.Int).SetUint64(t)
        bt.Exp(bp, bt, nil)
        k.Mul(k, bt)
    }
    g := big.NewInt(1)
    for (g.Cmp(one) == 0 || g.Cmp(n) == 0) && curves <= maxCurves {
        curves++
        st := int64(6 + rand.Intn(maxRnd-5))
        sigma := big.NewInt(st)

        // generate a new random curve in Montgomery form with Suyama's parameterization
        u := new(big.Int).Mul(sigma, sigma)
        u.Sub(u, five)
        u.Mod(u, n)
        v := new(big.Int).Mul(four, sigma)
        v.Mod(v, n)
        vmu := new(big.Int).Sub(v, u)
        a := new(big.Int).Mul(vmu, vmu)
        a.Mul(a, vmu)
        t := new(big.Int).Mul(three, u)
        t.Add(t, v)
        a.Mul(a, t)
        t.Mul(four, u)
        t.Mul(t, u)
        t.Mul(t, u)
        t.Mul(t, v)
        a.Quo(a, t)
        a.Sub(a, two)
        a.Mod(a, n)
        a24 := new(big.Int).Add(a, two)
        a24.Quo(a24, four)

        // stage 1
        px := new(big.Int).Mul(u, u)
        px.Mul(px, u)
        t.Mul(v, v)
        t.Mul(t, v)
        px.Quo(px, t)
        px.Mod(px, n)
        pz := big.NewInt(1)
        qx, qz := scalarMultiply(k, px, pz, n, a24)
        g.GCD(nil, nil, n, qz)

        // if stage 1 is successful, return a non-trivial factor else
        // move on to stage 2
        if g.Cmp(one) != 0 && g.Cmp(n) != 0 {
            return g, nil
        }

        // stage 2
        s[1], s[2] = pointDouble(qx, qz, n, a24)
        s[3], s[4] = pointDouble(s[1], s[2], n, a24)
        beta[1].Mul(s[1], s[2])
        beta[1].Mod(beta[1], n)
        beta[2].Mul(s[3], s[4])
        beta[2].Mod(beta[2], n)
        for d := uint64(3); d <= dd; d++ {
            d2 := 2 * d
            s[d2-1], s[d2] = pointAdd(s[d2-3], s[d2-2], s[1], s[2], s[d2-5], s[d2-4], n)
            beta[d].Mul(s[d2-1], s[d2])
            beta[d].Mod(beta[d], n)
        }
        g.SetUint64(1)
        b := new(big.Int).SetUint64(b1 - 1)
        rx, rz := scalarMultiply(b, qx, qz, n, a24)
        t.Mul(two, new(big.Int).SetUint64(dd))
        t.Sub(b, t)
        tx, tz := scalarMultiply(t, qx, qz, n, a24)
        q, step := idxB1, 2*dd
        for r := b1 - 1; r < b2; r += step {
            alpha := new(big.Int).Mul(rx, rz)
            alpha.Mod(alpha, n)
            limit := r + step
            for q < numPrimes && primes[q] <= limit {
                d := (primes[q] - r) / 2
                t := new(big.Int).Sub(rx, s[2*d-1])
                f := new(big.Int).Add(rz, s[2*d])
                f.Mul(t, f)
                f.Sub(f, alpha)
                f.Add(f, beta[d])
                g.Mul(g, f)
                g.Mod(g, n)
                q++
            }
            trx := new(big.Int).Set(rx)
            trz := new(big.Int).Set(rz)
            rx, rz = pointAdd(rx, rz, s[2*dd-1], s[2*dd], tx, tz, n)
            tx.Set(trx)
            tz.Set(trz)
        }
        g.GCD(nil, nil, n, g)
    }

    // no non-trivial factor found, return an error
    if curves > maxCurves {
        return zero, fmt.Errorf("maximum curves exceeded before a factor was found")
    }
    return g, nil
}

// find prime factors of 'n' using an appropriate method.
func primeFactors(n *big.Int) ([]*big.Int, error) {
    var res []*big.Int
    if n.ProbablyPrime(10) {
        return append(res, n), nil
    }
    le := len(n.String())
    var factor1 *big.Int
    var err error
    if le > 20 && le <= 60 {
        factor1, err = ecm(n)
    } else {
        factor1, err = pollardRho(n)
    }
    if err != nil {
        return nil, err
    }
    if !factor1.ProbablyPrime(10) {
        return nil, fmt.Errorf("first factor is not prime")
    }
    factor2 := new(big.Int)
    factor2.Quo(n, factor1)
    if !factor2.ProbablyPrime(10) {
        return nil, fmt.Errorf("%d (second factor is not prime)", factor1)
    }
    return append(res, factor1, factor2), nil
}

func fermatNumbers(n int) (res []*big.Int) {
    f := new(big.Int).SetUint64(3) // 2^1 + 1
    for i := 0; i < n; i++ {
        t := new(big.Int).Set(f)
        res = append(res, t)
        f.Sub(f, one)
        f.Mul(f, f)
        f.Add(f, one)
    }
    return res
}

func main() {
    start := time.Now()
    rand.Seed(time.Now().UnixNano())
    fns := fermatNumbers(10)
    fmt.Println("First 10 Fermat numbers:")
    for i, f := range fns {
        fmt.Printf("F%c = %d\n", 0x2080+i, f)
    }

    fmt.Println("\nFactors of first 10 Fermat numbers:")
    for i, f := range fns {
        fmt.Printf("F%c = ", 0x2080+i)
        factors, err := primeFactors(f)
        if err != nil {
            fmt.Println(err)
            continue
        }
        for _, factor := range factors {
            fmt.Printf("%d ", factor)
        }
        if len(factors) == 1 {
            fmt.Println("- prime")
        } else {
            fmt.Println()
        }
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
