package main

import (
    "fmt"
    "rcu"
)

const limit = 100000 // say

func nonTwinSums(twins []int) []int {
    sieve := make([]bool, limit+1)
    for i := 0; i < len(twins); i++ {
        for j := i; j < len(twins); j++ {
            sum := twins[i] + twins[j]
            if sum > limit {
                break
            }
            sieve[sum] = true
        }
    }
    var res []int
    for i := 2; i < limit; i += 2 {
        if !sieve[i] {
            res = append(res, i)
        }
    }
    return res
}

func main() {
    primes := rcu.Primes(limit)[2:] // exclude 2 and 3
    twins := []int{3}
    for i := 0; i < len(primes)-1; i++ {
        if primes[i+1]-primes[i] == 2 {
            if twins[len(twins)-1] != primes[i] {
                twins = append(twins, primes[i])
            }
            twins = append(twins, primes[i+1])
        }
    }
    fmt.Println("Non twin prime sums:")
    ntps := nonTwinSums(twins)
    rcu.PrintTable(ntps, 10, 4, false)
    fmt.Println("Found", len(ntps))

    fmt.Println("\nNon twin prime sums (including 1):")
    twins = append([]int{1}, twins...)
    ntps = nonTwinSums(twins)
    rcu.PrintTable(ntps, 10, 4, false)
    fmt.Println("Found", len(ntps))
}
