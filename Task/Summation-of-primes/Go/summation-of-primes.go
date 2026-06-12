package main

import (
    "fmt"
    "rcu"
)

func main() {
    sum := 0
    for _, p := range rcu.Primes(1_999_999) {
        sum += p
    }
    fmt.Printf("The sum of all primes below 2 million is %s.\n", rcu.Commatize(sum))
}
