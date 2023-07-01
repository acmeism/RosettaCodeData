package main

import(
    "golang.org/x/text/language"
    "golang.org/x/text/message"
)

func isPrime(n uint64) bool {
    if n % 2 == 0 {
        return n == 2
    }
    if n % 3 == 0 {
        return n == 3
    }
    d := uint64(5)
    for d * d <= n {
        if n % d == 0 {
            return false
        }
        d += 2
        if n % d == 0 {
            return false
        }
        d += 4
    }
    return true
}

const limit = 42

func main() {
    p := message.NewPrinter(language.English)
    for i, n := uint64(limit), 0; n < limit; i++ {
        if isPrime(i) {
            n++
            p.Printf("n = %-2d  %19d\n", n, i)
            i += i - 1
        }
    }
}
