package main

import (
    "fmt"
    "math/big"
    "rcu"
)

func lcm(n int) *big.Int {
    lcm := big.NewInt(1)
    t := new(big.Int)
    for _, p := range rcu.Primes(n) {
        f := p
        for f*p <= n {
            f *= p
        }
        lcm.Mul(lcm, t.SetUint64(uint64(f)))
    }
    return lcm
}

func main() {
    fmt.Println("The LCMs of the numbers 1 to N inclusive is:")
    for _, i := range []int{10, 20, 200, 2000} {
        fmt.Printf("%4d: %s\n", i, lcm(i))
    }
}
