package main

import "fmt"

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

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func strangePrimes(n int, countOnly bool) int {
    c := 0
    f := "%2d: %2d + %2d + %2d = %2d\n"
    var s int

    for i := 3; i <= n-4; i += 2 {
        if isPrime(i) {
            for j := i + 2; j <= n-2; j += 2 {
                if isPrime(j) {
                    for k := j + 2; k <= n; k += 2 {
                        if isPrime(k) {
                            s = i + j + k
                            if isPrime(s) {
                                c++
                                if !countOnly {
                                    fmt.Printf(f, c, i, j, k, s)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return c
}

func main() {
    fmt.Println("Unique prime triples under 30 which sum to a prime:")
    strangePrimes(29, false)
    cs := commatize(strangePrimes(999, true))
    fmt.Printf("\nThere are %s unique prime triples under 1,000 which sum to a prime.\n", cs)
}
