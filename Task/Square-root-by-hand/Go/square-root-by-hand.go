package main

import (
    "fmt"
    "math/big"
)

var one = big.NewInt(1)
var ten = big.NewInt(10)
var twenty = big.NewInt(20)
var hundred = big.NewInt(100)

func sqrt(n float64, limit int) {
    if n < 0 {
        log.Fatal("Number cannot be negative")
    }
    count := 0
    for n != math.Trunc(n) {
        n *= 100
        count--
    }
    i := big.NewInt(int64(n))
    j := new(big.Int).Sqrt(i)
    count += len(j.String())
    k := new(big.Int).Set(j)
    d := new(big.Int).Set(j)
    t := new(big.Int)
    digits := 0
    var sb strings.Builder
    for digits < limit {
        sb.WriteString(d.String())
        t.Mul(k, d)
        i.Sub(i, t)
        i.Mul(i, hundred)
        k.Mul(j, twenty)
        d.Set(one)
        for d.Cmp(ten) <= 0 {
            t.Add(k, d)
            t.Mul(t, d)
            if t.Cmp(i) > 0 {
                d.Sub(d, one)
                break
            }
            d.Add(d, one)
        }
        j.Mul(j, ten)
        j.Add(j, d)
        k.Add(k, d)
        digits = digits + 1
    }
    root := strings.TrimRight(sb.String(), "0")
    if len(root) == 0 {
        root = "0"
    }
    if count > 0 {
        root = root[0:count] + "." + root[count:]
    } else if count == 0 {
        root = "0." + root
    } else {
        root = "0." + strings.Repeat("0", -count) + root
    }
    root = strings.TrimSuffix(root, ".")
    fmt.Println(root)
}

func main() {
    numbers := []float64{2, 0.2, 10.89, 625, 0.0001}
    digits := []int{500, 80, 8, 8, 8}
    for i, n := range numbers {
        fmt.Printf("First %d significant digits (at most) of the square root of %g:\n", digits[i], n)
        sqrt(n, digits[i])
        fmt.Println()
    }
}
