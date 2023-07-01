package main

import (
    "fmt"
    "math/big"
    "rcu"
)

func main() {
    count := 0
    limit := 25
    n := int64(17)
    repunit := big.NewInt(1111111111111111)
    t := new(big.Int)
    zero := new(big.Int)
    eleven := big.NewInt(11)
    hundred := big.NewInt(100)
    var deceptive []int64
    for count < limit {
        if !rcu.IsPrime(int(n)) && n%3 != 0 && n%5 != 0 {
            bn := big.NewInt(n)
            if t.Rem(repunit, bn).Cmp(zero) == 0 {
                deceptive = append(deceptive, n)
                count++
            }
        }
        n += 2
        repunit.Mul(repunit, hundred)
        repunit.Add(repunit, eleven)
    }
    fmt.Println("The first", limit, "deceptive numbers are:")
    fmt.Println(deceptive)
}
