package main

import "fmt"

func sieve(limit int) []bool {
    limit++
    // True denotes composite, false denotes prime.
    // Don't bother marking even numbers >= 4 as composite.
    c := make([]bool, limit)
    c[0] = true
    c[1] = true

    p := 3 // start from 3
    for {
        p2 := p * p
        if p2 >= limit {
            break
        }
        for i := p2; i < limit; i += 2 * p {
            c[i] = true
        }
        for {
            p += 2
            if !c[p] {
                break
            }
        }
    }
    return c
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    // sieve up to 10,000,019 - the first prime after 10 million
    const limit = 1e7 + 19
    sieved := sieve(limit)
    // extract primes
    var primes = []int{2}
    for i := 3; i <= limit; i += 2 {
        if !sieved[i] {
            primes = append(primes, i)
        }
    }
    // extract strong and weak primes
    var strong []int
    var weak = []int{3}                  // so can use integer division for rest
    for i := 2; i < len(primes)-1; i++ { // start from 5
        if primes[i] > (primes[i-1]+primes[i+1])/2 {
            strong = append(strong, primes[i])
        } else if primes[i] < (primes[i-1]+primes[i+1])/2 {
            weak = append(weak, primes[i])
        }
    }

    fmt.Println("The first 36 strong primes are:")
    fmt.Println(strong[:36])
    count := 0
    for _, p := range strong {
        if p >= 1e6 {
            break
        }
        count++
    }
    fmt.Println("\nThe number of strong primes below 1,000,000 is", commatize(count))
    fmt.Println("\nThe number of strong primes below 10,000,000 is", commatize(len(strong)))

    fmt.Println("\nThe first 37 weak primes are:")
    fmt.Println(weak[:37])
    count = 0
    for _, p := range weak {
        if p >= 1e6 {
            break
        }
        count++
    }
    fmt.Println("\nThe number of weak primes below 1,000,000 is", commatize(count))
    fmt.Println("\nThe number of weak primes below 10,000,000 is", commatize(len(weak)))
}
