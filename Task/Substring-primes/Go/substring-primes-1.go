package main

import (
    "fmt"
    "rcu"
)

func main() {
    primes := rcu.Primes(499)
    var sprimes []int
    for _, p := range primes {
        digits := rcu.Digits(p, 10)
        var b1 = true
        for _, d := range digits {
            if !rcu.IsPrime(d) {
                b1 = false
                break
            }
        }
        if b1 {
            if len(digits) < 3 {
                sprimes = append(sprimes, p)
            } else {
                b2 := rcu.IsPrime(digits[0]*10 + digits[1])
                b3 := rcu.IsPrime(digits[1]*10 + digits[2])
                if b2 && b3 {
                    sprimes = append(sprimes, p)
                }
            }
        }
    }
    fmt.Println("Found", len(sprimes), "primes < 500 where all substrings are also primes, namely:")
    fmt.Println(sprimes)
}
