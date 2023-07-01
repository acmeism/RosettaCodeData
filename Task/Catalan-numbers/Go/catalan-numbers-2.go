package main

import (
        "fmt"
        "math/big"
)

func c(n int64) *big.Int {
        if n == 0 {
                return big.NewInt(1)
        } else {
                var t1, t2, t3, t4, t5, t6 big.Int
                t1.Mul(big.NewInt(2), big.NewInt(n))
                t2.Sub(&t1, big.NewInt(1))
                t3.Mul(big.NewInt(2), &t2)
                t4.Add(big.NewInt(n), big.NewInt(1))
                t5.Mul(&t3, c(n-1))
                t6.Div(&t5, &t4)
                return &t6
        }
}

func main() {
        for n := int64(1); n < 16; n++ {
                fmt.Println(c(n))
        }
}
