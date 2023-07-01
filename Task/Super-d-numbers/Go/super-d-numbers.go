package main

import (
    "fmt"
    "math/big"
    "strings"
    "time"
)

func main() {
    start := time.Now()
    rd := []string{"22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999"}
    one := big.NewInt(1)
    nine := big.NewInt(9)
    for i := big.NewInt(2); i.Cmp(nine) <= 0; i.Add(i, one) {
        fmt.Printf("First 10 super-%d numbers:\n", i)
        ii := i.Uint64()
        k := new(big.Int)
        count := 0
    inner:
        for j := big.NewInt(3); ; j.Add(j, one) {
            k.Exp(j, i, nil)
            k.Mul(i, k)
            ix := strings.Index(k.String(), rd[ii-2])
            if ix >= 0 {
                count++
                fmt.Printf("%d ", j)
                if count == 10 {
                    fmt.Printf("\nfound in %d ms\n\n", time.Since(start).Milliseconds())
                    break inner
                }
            }
        }
    }
}
