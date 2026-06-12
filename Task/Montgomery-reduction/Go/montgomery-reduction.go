package main

import (
    "fmt"
    "math/big"
    "math/rand"
    "time"
)

// mont holds numbers useful for working in Mongomery representation.
type mont struct {
    n  uint     // m.BitLen()
    m  *big.Int // modulus, must be odd
    r2 *big.Int // (1<<2n) mod m
}

// constructor
func newMont(m *big.Int) *mont {
    if m.Bit(0) != 1 {
        return nil
    }
    n := uint(m.BitLen())
    x := big.NewInt(1)
    x.Sub(x.Lsh(x, n), m)
    return &mont{n, new(big.Int).Set(m), x.Mod(x.Mul(x, x), m)}
}

// Montgomery reduction algorithm
func (m mont) reduce(t *big.Int) *big.Int {
    a := new(big.Int).Set(t)
    for i := uint(0); i < m.n; i++ {
        if a.Bit(0) == 1 {
            a.Add(a, m.m)
        }
        a.Rsh(a, 1)
    }
    if a.Cmp(m.m) >= 0 {
        a.Sub(a, m.m)
    }
    return a
}

// example use:
func main() {
    const n = 100 // bit length for numbers in example

    // generate random n-bit odd number for modulus m
    rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
    one := big.NewInt(1)
    r1 := new(big.Int).Lsh(one, n-1)
    r2 := new(big.Int).Lsh(one, n-2)
    m := new(big.Int)
    m.Or(r1, m.Or(m.Lsh(m.Rand(rnd, r2), 1), one))

    // make Montgomery reduction object around m
    mr := newMont(m)

    // generate a couple more numbers in the range 0..m.
    // these are numbers we will do some computations on, mod m.
    x1 := new(big.Int).Rand(rnd, m)
    x2 := new(big.Int).Rand(rnd, m)

    // t1, t2 are examples of T, from the task description.
    // Generated this way, they will be in the range 0..m^2, and so < mR.
    t1 := new(big.Int).Mul(x1, mr.r2)
    t2 := new(big.Int).Mul(x2, mr.r2)

    // reduce.  r1 and r2 are now montgomery representations of x1 and x2.
    r1 = mr.reduce(t1)
    r2 = mr.reduce(t2)

    // this is the end of what is described in the task so far.
    fmt.Println("b:  2")
    fmt.Println("n: ", mr.n)
    fmt.Println("r: ", new(big.Int).Lsh(one, mr.n))
    fmt.Println("m: ", mr.m)
    fmt.Println("t1:", t1)
    fmt.Println("t2:", t2)
    fmt.Println("r1:", r1)
    fmt.Println("r2:", r2)

    // but now demonstrate that it works:
    fmt.Println()
    fmt.Println("Original x1:       ", x1)
    fmt.Println("Recovererd from r1:", mr.reduce(r1))
    fmt.Println("Original x2:       ", x2)
    fmt.Println("Recovererd from r2:", mr.reduce(r2))

    // and demonstrate a use:
    fmt.Println("\nMontgomery computation of x1 ^ x2 mod m:")
    // this is the modular exponentiation algorithm, except we call
    // mont.reduce instead of using a mod function.
    prod := mr.reduce(mr.r2)             // 1
    base := mr.reduce(t1.Mul(x1, mr.r2)) // x1^1
    exp := new(big.Int).Set(x2)          // not reduced
    for exp.BitLen() > 0 {
        if exp.Bit(0) == 1 {
            prod = mr.reduce(prod.Mul(prod, base))
        }
        exp.Rsh(exp, 1)
        base = mr.reduce(base.Mul(base, base))
    }
    fmt.Println(mr.reduce(prod))

    // show library-based equivalent computation as a check
    fmt.Println("\nLibrary-based computation of x1 ^ x2 mod m:")
    fmt.Println(new(big.Int).Exp(x1, x2, m))
}
