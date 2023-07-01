package main

import (
    "fmt"
    "math"
    "math/big"
    "strconv"
    "strings"
)

func calkinWilf(n int) []*big.Rat {
    cw := make([]*big.Rat, n+1)
    cw[0] = big.NewRat(1, 1)
    one := big.NewRat(1, 1)
    two := big.NewRat(2, 1)
    for i := 1; i < n; i++ {
        t := new(big.Rat).Set(cw[i-1])
        f, _ := t.Float64()
        f = math.Floor(f)
        t.SetFloat64(f)
        t.Mul(t, two)
        t.Sub(t, cw[i-1])
        t.Add(t, one)
        t.Inv(t)
        cw[i] = new(big.Rat).Set(t)
    }
    return cw
}

func toContinued(r *big.Rat) []int {
    a := r.Num().Int64()
    b := r.Denom().Int64()
    var res []int
    for {
        res = append(res, int(a/b))
        t := a % b
        a, b = b, t
        if a == 1 {
            break
        }
    }
    le := len(res)
    if le%2 == 0 { // ensure always odd
        res[le-1]--
        res = append(res, 1)
    }
    return res
}

func getTermNumber(cf []int) int {
    b := ""
    d := "1"
    for _, n := range cf {
        b = strings.Repeat(d, n) + b
        if d == "1" {
            d = "0"
        } else {
            d = "1"
        }
    }
    i, _ := strconv.ParseInt(b, 2, 64)
    return int(i)
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func main() {
    cw := calkinWilf(20)
    fmt.Println("The first 20 terms of the Calkin-Wilf sequnence are:")
    for i := 1; i <= 20; i++ {
        fmt.Printf("%2d: %s\n", i, cw[i-1].RatString())
    }
    fmt.Println()
    r := big.NewRat(83116, 51639)
    cf := toContinued(r)
    tn := getTermNumber(cf)
    fmt.Printf("%s is the %sth term of the sequence.\n", r.RatString(), commatize(tn))
}
