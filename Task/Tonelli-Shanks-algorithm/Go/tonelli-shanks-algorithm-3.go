package main

import (
    "fmt"
    "math/big"
)

func main() {
    var n, p, R1, R2 big.Int
    n.SetInt64(665820697)
    p.SetInt64(1000000009)
    R1.ModSqrt(&n, &p)
    R2.Sub(&p, &R1)
    fmt.Println(&R1, &R2)

    n.SetInt64(881398088036)
    p.SetInt64(1000000000039)
    R1.ModSqrt(&n, &p)
    R2.Sub(&p, &R1)
    fmt.Println(&R1, &R2)

    n.SetString("41660815127637347468140745042827704103445750172002", 10)
    p.SetString("100000000000000000000000000000000000000000000000577", 10)
    R1.ModSqrt(&n, &p)
    R2.Sub(&p, &R1)
    fmt.Println(&R1)
    fmt.Println(&R2)
}
