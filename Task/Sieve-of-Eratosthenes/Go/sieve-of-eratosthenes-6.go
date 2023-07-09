package main

import "fmt"

func main() {
    primes := make(chan int)
    go PrimeSieve(primes)

    p := <-primes
    for p < 100 {
        fmt.Printf("%d ", p)
        p = <-primes
    }

    fmt.Println()
}

func PrimeSieve(out chan int) {
    out <- 2
    out <- 3

    primes := make(chan int)
    go PrimeSieve(primes)

    var p int
    <-primes
    p = <-primes

    sieve := make(map[int]int)
    q := p * p
    n := p

    for {
        n += 2
        step, isComposite := sieve[n]
        if isComposite {
            delete(sieve, n)
            m := n + step
            for sieve[m] != 0 {
                m += step
            }
            sieve[m] = step

        } else if n < q {
            out <- n

        } else {
            step = p + p
            m := n + step
            for sieve[m] != 0 {
                m += step
            }
            sieve[m] = step
            p = <-primes
            q = p * p
        }
    }
}
