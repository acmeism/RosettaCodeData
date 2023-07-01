package main

import (
    "fmt"
    "math/big"
    "rcu"
)

func main() {
    primes := rcu.Primes(5000)
    zero := new(big.Int)
    one := big.NewInt(1)
    num := new(big.Int)
    fmt.Println("Wieferich primes < 5,000:")
    for _, p := range primes {
        num.Set(one)
        num.Lsh(num, uint(p-1))
        num.Sub(num, one)
        den := big.NewInt(int64(p * p))
        if num.Rem(num, den).Cmp(zero) == 0 {
            fmt.Println(rcu.Commatize(p))
        }
    }
}
