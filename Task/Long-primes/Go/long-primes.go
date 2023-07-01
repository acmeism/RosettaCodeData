package main

import "fmt"

func sieve(limit int) []int {
    var primes []int
    c := make([]bool, limit + 1) // composite = true
    // no need to process even numbers
    p := 3
    p2 := p * p
    for p2 <= limit {
        for i := p2; i <= limit; i += 2 * p {
            c[i] = true
        }
        for ok := true; ok; ok = c[p] {
            p += 2
        }
        p2 = p * p
    }
    for i := 3; i <= limit; i += 2 {
        if !c[i] {
            primes = append(primes, i)
        }
    }
    return primes
}

// finds the period of the reciprocal of n
func findPeriod(n int) int {
    r := 1
    for i := 1; i <= n + 1; i++ {
        r = (10 * r) % n
    }
    rr := r
    period := 0
    for ok := true; ok; ok = r != rr {
        r = (10 * r) % n
        period++
    }
    return period
}

func main() {
    primes := sieve(64000)
    var longPrimes []int
    for _, prime := range primes {
        if findPeriod(prime) == prime - 1 {
            longPrimes = append(longPrimes, prime)
        }
    }
    numbers := []int{500, 1000, 2000, 4000, 8000, 16000, 32000, 64000}
    index := 0
    count := 0
    totals := make([]int, len(numbers))
    for _, longPrime := range longPrimes {
        if longPrime > numbers[index] {
            totals[index] = count
            index++
        }
        count++
    }
    totals[len(numbers)-1] = count
    fmt.Println("The long primes up to", numbers[0], "are: ")
    fmt.Println(longPrimes[:totals[0]])

    fmt.Println("\nThe number of long primes up to: ")
    for i, total := range totals {
        fmt.Printf("  %5d is %d\n", numbers[i], total)
    }
}
