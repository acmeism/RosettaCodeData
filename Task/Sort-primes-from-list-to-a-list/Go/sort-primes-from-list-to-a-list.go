package main

import (
    "fmt"
    "rcu"
    "sort"
)

func main() {
    list := []int{2, 43, 81, 122, 63, 13, 7, 95, 103}
    var primes []int
    for _, e := range list {
        if rcu.IsPrime(e) {
            primes = append(primes, e)
        }
    }
    sort.Ints(primes)
    fmt.Println(primes)
}
