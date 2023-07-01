package main

import (
    "fmt"
    "math/big"
)

var (
    one   = new(big.Int).SetUint64(1)
    two   = new(big.Int).SetUint64(2)
    three = new(big.Int).SetUint64(3)
    five  = new(big.Int).SetUint64(5)
    seven = new(big.Int).SetUint64(7)
    ten   = new(big.Int).SetUint64(10)
)

func min(a, b *big.Int) *big.Int {
    if a.Cmp(b) < 0 {
        return a
    }
    return b
}

func humble(n int) []*big.Int {
    h := make([]*big.Int, n)
    h[0] = new(big.Int).Set(one)
    next2, next3 := new(big.Int).Set(two), new(big.Int).Set(three)
    next5, next7 := new(big.Int).Set(five), new(big.Int).Set(seven)
    var i, j, k, l int
    for m := 1; m < len(h); m++ {
        h[m] = new(big.Int).Set(min(next2, min(next3, min(next5, next7))))
        if h[m].Cmp(next2) == 0 {
            i++
            next2.Mul(two, h[i])
        }
        if h[m].Cmp(next3) == 0 {
            j++
            next3.Mul(three, h[j])
        }
        if h[m].Cmp(next5) == 0 {
            k++
            next5.Mul(five, h[k])
        }
        if h[m].Cmp(next7) == 0 {
            l++
            next7.Mul(seven, h[l])
        }
    }
    return h
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    const n = 13 * 1e6  // calculate the first 13 million humble numbers, say
    h := humble(n)
    fmt.Println("The first 50 humble numbers are:")
    fmt.Println(h[0:50])

    maxDigits := len(h[len(h)-1].String()) - 1
    counts := make([]int, maxDigits+1)
    var maxUsed int
    digits := 1
    pow10 := new(big.Int).Set(ten)
    for i := 0; i < len(h); i++ {
        for {
            if h[i].Cmp(pow10) >= 0 {
                pow10.Mul(pow10, ten)
                digits++
            } else {
                break
            }
        }
        if digits > maxDigits {
            maxUsed = i
            break
        }
        counts[digits]++
    }
    fmt.Printf("\nOf the first %s humble numbers:\n", commatize(maxUsed))
    for i := 1; i <= maxDigits; i++ {
        s := "s"
        if i == 1 {
            s = ""
        }
        fmt.Printf("%9s have %2d digit%s\n", commatize(counts[i]), i, s)
    }
}
