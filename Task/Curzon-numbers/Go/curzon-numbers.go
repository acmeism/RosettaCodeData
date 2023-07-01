package main

import (
    "fmt"
    "math/big"
)

func main() {
    zero := big.NewInt(0)
    one := big.NewInt(1)
    for k := int64(2); k <= 10; k += 2 {
        bk := big.NewInt(k)
        fmt.Println("The first 50 Curzon numbers using a base of", k, ":")
        count := 0
        n := int64(1)
        pow := big.NewInt(k)
        z := new(big.Int)
        var curzon50 []int64
        for {
            z.Add(pow, one)
            d := k*n + 1
            bd := big.NewInt(d)
            if z.Rem(z, bd).Cmp(zero) == 0 {
                if count < 50 {
                    curzon50 = append(curzon50, n)
                }
                count++
                if count == 50 {
                    for i := 0; i < len(curzon50); i++ {
                        fmt.Printf("%4d ", curzon50[i])
                        if (i+1)%10 == 0 {
                            fmt.Println()
                        }
                    }
                    fmt.Print("\nOne thousandth: ")
                }
                if count == 1000 {
                    fmt.Println(n)
                    break
                }
            }
            n++
            pow.Mul(pow, bk)
        }
        fmt.Println()
    }
}
