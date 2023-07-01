package main

import (
    "fmt"
    "math/big"
    "strings"
)

func factorial(n int64) *big.Int {
    var z big.Int
    return z.MulRange(1, n)
}

var one = big.NewInt(1)
var three = big.NewInt(3)
var six = big.NewInt(6)
var ten = big.NewInt(10)
var seventy = big.NewInt(70)

func almkvistGiullera(n int64, print bool) *big.Rat {
    t1 := big.NewInt(32)
    t1.Mul(factorial(6*n), t1)
    t2 := big.NewInt(532*n*n + 126*n + 9)
    t3 := new(big.Int)
    t3.Exp(factorial(n), six, nil)
    t3.Mul(t3, three)
    ip := new(big.Int)
    ip.Mul(t1, t2)
    ip.Quo(ip, t3)
    pw := 6*n + 3
    t1.SetInt64(pw)
    tm := new(big.Rat).SetFrac(ip, t1.Exp(ten, t1, nil))
    if print {
        fmt.Printf("%d  %44d  %3d  %-35s\n", n, ip, -pw, tm.FloatString(33))
    }
    return tm
}

func main() {
    fmt.Println("N                               Integer Portion  Pow  Nth Term (33 dp)")
    fmt.Println(strings.Repeat("-", 89))
    for n := int64(0); n < 10; n++ {
        almkvistGiullera(n, true)
    }

    sum := new(big.Rat)
    prev := new(big.Rat)
    pow70 := new(big.Int).Exp(ten, seventy, nil)
    prec := new(big.Rat).SetFrac(one, pow70)
    n := int64(0)
    for {
        term := almkvistGiullera(n, false)
        sum.Add(sum, term)
        z := new(big.Rat).Sub(sum, prev)
        z.Abs(z)
        if z.Cmp(prec) < 0 {
            break
        }
        prev.Set(sum)
        n++
    }
    sum.Inv(sum)
    pi := new(big.Float).SetPrec(256).SetRat(sum)
    pi.Sqrt(pi)
    fmt.Println("\nPi to 70 decimal places is:")
    fmt.Println(pi.Text('f', 70))
}
