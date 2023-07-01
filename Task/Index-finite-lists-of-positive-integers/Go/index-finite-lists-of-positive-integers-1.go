package main

import (
    "fmt"
    "math/big"
)

func rank(l []uint) (r big.Int) {
    for _, n := range l {
        r.Lsh(&r, n+1)
        r.SetBit(&r, int(n), 1)
    }
    return
}

func unrank(n big.Int) (l []uint) {
    m := new(big.Int).Set(&n)
    for a := m.BitLen(); a > 0; {
        m.SetBit(m, a-1, 0)
        b := m.BitLen()
        l = append(l, uint(a-b-1))
        a = b
    }
    return
}

func main() {
    var b big.Int
    for i := 0; i <= 10; i++ {
        b.SetInt64(int64(i))
        u := unrank(b)
        r := rank(u)
        fmt.Println(i, u, &r)
    }
    b.SetString("12345678901234567890", 10)
    u := unrank(b)
    r := rank(u)
    fmt.Printf("\n%v\n%d\n%d\n", &b, u, &r)
}
