package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "rcu"
    "strconv"
    "strings"
)

func ord(count int) string {
    if count == 1 {
        return "st"
    }
    if count == 2 {
        return "nd"
    }
    if count == 3 {
        return "rd"
    }
    return "th"
}

func main() {
    primes := rcu.Primes(12000)
    sw := ""
    count := 0
    i := 0
    n := new(big.Int)
    fmt.Println("The known Smarandache-Wellin primes are:")
    for count < 8 {
        sw += strconv.Itoa(primes[i])
        n.SetString(sw, 10)
        if n.ProbablyPrime(15) {
            count++
            sws := sw
            le := len(sws)
            if le > 4 {
                sws = sws[0:20] + "..." + sws[le-20:le]
            }
            fmt.Printf("%d%s: index %4d  digits %4d  last prime %5d -> %s\n", count, ord(count), i+1, len(sw), primes[i], sws)
        }
        i++
    }

    fmt.Println("\nThe first 20 Derived Smarandache-Wellin primes are:")
    freqs := make([]int, 10)
    count = 0
    i = 0
    for count < 20 {
        p := strconv.Itoa(primes[i])
        for _, d := range p {
            n, _ := strconv.Atoi(string(d))
            freqs[n]++
        }
        dsw := ""
        for _, freq := range freqs {
            dsw += strconv.Itoa(freq)
        }
        dsw = strings.TrimLeft(dsw, "0")
        n.SetString(dsw, 10)
        if n.ProbablyPrime(15) {
            count++
            fmt.Printf("%2d%s: index %4d  prime %v\n", count, ord(count), i+1, n)
        }
        i++
    }
}
