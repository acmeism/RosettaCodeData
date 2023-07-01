package main

import "fmt"

// OK for 'small' numbers.
func isPrime(n uint64) bool {
    switch {
    case n < 2:
        return false
    case n%2 == 0:
        return n == 2
    case n%3 == 0:
        return n == 3
    default:
        d := uint64(5)
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

func ord(n int) string {
    m := n % 100
    if m >= 4 && m <= 20 {
        return fmt.Sprintf("%dth", n)
    }
    m %= 10
    suffix := "th"
    if m < 4 {
        switch m {
        case 1:
            suffix = "st"
        case 2:
            suffix = "nd"
        case 3:
            suffix = "rd"
        }
    }
    return fmt.Sprintf("%d%s", n, suffix)
}

func isMagnanimous(n uint64) bool {
    if n < 10 {
        return true
    }
    for p := uint64(10); ; p *= 10 {
        q := n / p
        r := n % p
        if !isPrime(q + r) {
            return false
        }
        if q < 10 {
            break
        }
    }
    return true
}

func listMags(from, thru, digs, perLine int) {
    if from < 2 {
        fmt.Println("\nFirst", thru, "magnanimous numbers:")
    } else {
        fmt.Printf("\n%s through %s magnanimous numbers:\n", ord(from), ord(thru))
    }
    for i, c := uint64(0), 0; c < thru; i++ {
        if isMagnanimous(i) {
            c++
            if c >= from {
                fmt.Printf("%*d ", digs, i)
                if c%perLine == 0 {
                    fmt.Println()
                }
            }
        }
    }
}

func main() {
    listMags(1, 45, 3, 15)
    listMags(241, 250, 1, 10)
    listMags(391, 400, 1, 10)
}
