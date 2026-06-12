package main

import (
    "fmt"
    "rcu"
)

func main() {
    results := []int{2, 3, 5, 7} // number must begin with a prime digit
    odigits := []int{3, 7}       // other digits must be 3 or 7
    var discarded []int
    tests := 4 // i.e. to obtain initial results in the first place

    // check 2 digit numbers or greater
    // note that 'results' is a moving feast. If the loop eventually terminates that's all there are.
    for i := 0; i < len(results); i++ {
        r := results[i]
        for _, od := range odigits {
            // the last digit of r and od must be different otherwise number would be divisible by 11
            if (r % 10) != od {
                n := r*10 + od
                if rcu.IsPrime(n) {
                    results = append(results, n)
                } else {
                    discarded = append(discarded, n)
                }
                tests++
            }
        }
    }
    fmt.Println("There are", len(results), "primes where all substrings are also primes, namely:")
    fmt.Println(results)
    fmt.Println("\nThe following numbers were also tested for primality but found to be composite:")
    fmt.Println(discarded)
    fmt.Println("\nTotal number of primality tests =", tests)
}
