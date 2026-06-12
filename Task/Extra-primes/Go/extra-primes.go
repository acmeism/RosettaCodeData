package main

import "fmt"

func isPrime(n int) bool {
    if n < 2 {
        return false
    }
    if n%2 == 0 {
        return n == 2
    }
    if n%3 == 0 {
        return n == 3
    }
    d := 5
    for d*d <= n {
        if n%d == 0 {
            return false
        }
        d += 2
        if n%d == 0 {
            return false
        }
        d += 4
    }
    return true
}

func main() {
    digits := [4]int{2, 3, 5, 7}                      // the only digits which are primes
    digits2 := [2]int{3, 7}                           // a prime > 5 can't end in 2 or 5
    cands := [][2]int{{2, 2}, {3, 3}, {5, 5}, {7, 7}} // {number, digits sum}

    for _, a := range digits {
        for _, b := range digits2 {
            cands = append(cands, [2]int{10*a + b, a + b})
        }
    }

    for _, a := range digits {
        for _, b := range digits {
            for _, c := range digits2 {
                cands = append(cands, [2]int{100*a + 10*b + c, a + b + c})
            }
        }
    }

    for _, a := range digits {
        for _, b := range digits {
            for _, c := range digits {
                for _, d := range digits2 {
                    cands = append(cands, [2]int{1000*a + 100*b + 10*c + d, a + b + c + d})
                }
            }
        }
    }

    fmt.Println("The extra primes under 10,000 are:")
    count := 0
    for _, cand := range cands {
        if isPrime(cand[0]) && isPrime(cand[1]) {
            count++
            fmt.Printf("%2d: %4d\n", count, cand[0])
        }
    }
}
