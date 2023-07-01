package main

import (
    "fmt"
    "math/big"
)

func main() {
    sequence()
    bank()
    rump()
}

func sequence() {
    // exact computations using big.Rat
    var v, v1 big.Rat
    v1.SetInt64(2)
    v.SetInt64(-4)
    n := 2
    c111 := big.NewRat(111, 1)
    c1130 := big.NewRat(1130, 1)
    c3000 := big.NewRat(3000, 1)
    var t2, t3 big.Rat
    r := func() (vn big.Rat) {
        vn.Add(vn.Sub(c111, t2.Quo(c1130, &v)), t3.Quo(c3000, t3.Mul(&v, &v1)))
        return
    }
    fmt.Println("  n  sequence value")
    for _, x := range []int{3, 4, 5, 6, 7, 8, 20, 30, 50, 100} {
        for ; n < x; n++ {
            v1, v = v, r()
        }
        f, _ := v.Float64()
        fmt.Printf("%3d %19.16f\n", n, f)
    }
}

func bank() {
    // balance as integer multiples of e and whole dollars using big.Int
    var balance struct{ e, d big.Int }
    // initial balance
    balance.e.SetInt64(1)
    balance.d.SetInt64(-1)
    // compute balance over 25 years
    var m, one big.Int
    one.SetInt64(1)
    for y := 1; y <= 25; y++ {
        m.SetInt64(int64(y))
        balance.e.Mul(&m, &balance.e)
        balance.d.Mul(&m, &balance.d)
        balance.d.Sub(&balance.d, &one)
    }
    // sum account components using big.Float
    var e, ef, df, b big.Float
    e.SetPrec(100).SetString("2.71828182845904523536028747135")
    ef.SetInt(&balance.e)
    df.SetInt(&balance.d)
    b.Add(b.Mul(&e, &ef), &df)
    fmt.Printf("Bank balance after 25 years: $%.2f\n", &b)
}

func rump() {
    a, b := 77617., 33096.
    fmt.Printf("Rump f(%g, %g): %g\n", a, b, f(a, b))
}

func f(a, b float64) float64 {
    // computations done with big.Float with enough precision to give
    // a correct answer.
    fp := func(x float64) *big.Float { return big.NewFloat(x).SetPrec(128) }
    a1 := fp(a)
    b1 := fp(b)
    a2 := new(big.Float).Mul(a1, a1)
    b2 := new(big.Float).Mul(b1, b1)
    b4 := new(big.Float).Mul(b2, b2)
    b6 := new(big.Float).Mul(b2, b4)
    b8 := new(big.Float).Mul(b4, b4)
    two := fp(2)
    t1 := fp(333.75)
    t1.Mul(t1, b6)
    t21 := fp(11)
    t21.Mul(t21.Mul(t21, a2), b2)
    t23 := fp(121)
    t23.Mul(t23, b4)
    t2 := new(big.Float).Sub(t21, b6)
    t2.Mul(a2, t2.Sub(t2.Sub(t2, t23), two))
    t3 := fp(5.5)
    t3.Mul(t3, b8)
    t4 := new(big.Float).Mul(two, b1)
    t4.Quo(a1, t4)
    s := new(big.Float).Add(t1, t2)
    f64, _ := s.Add(s.Add(s, t3), t4).Float64()
    return f64
}
