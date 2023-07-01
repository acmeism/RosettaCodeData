package main

import "fmt"

func sameDigits(n, b int) bool {
    f := n % b
    n /= b
    for n > 0 {
        if n%b != f {
            return false
        }
        n /= b
    }
    return true
}

func isBrazilian(n int) bool {
    if n < 7 {
        return false
    }
    if n%2 == 0 && n >= 8 {
        return true
    }
    for b := 2; b < n-1; b++ {
        if sameDigits(n, b) {
            return true
        }
    }
    return false
}

func isPrime(n int) bool {
    switch {
    case n < 2:
        return false
    case n%2 == 0:
        return n == 2
    case n%3 == 0:
        return n == 3
    default:
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
}

func main() {
    kinds := []string{" ", " odd ", " prime "}
    for _, kind := range kinds {
        fmt.Printf("First 20%sBrazilian numbers:\n", kind)
        c := 0
        n := 7
        for {
            if isBrazilian(n) {
                fmt.Printf("%d ", n)
                c++
                if c == 20 {
                    fmt.Println("\n")
                    break
                }
            }
            switch kind {
            case " ":
                n++
            case " odd ":
                n += 2
            case " prime ":
                for {
                    n += 2
                    if isPrime(n) {
                        break
                    }
                }
            }
        }
    }

    n := 7
    for c := 0; c < 100000; n++ {
        if isBrazilian(n) {
            c++
        }
    }
    fmt.Println("The 100,000th Brazilian number:", n-1)
}
