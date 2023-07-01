package main

import "fmt"

func gcd(a, b uint) uint {
    if b == 0 {
        return a
    }
    return gcd(b, a%b)
}

func lcm(a, b uint) uint {
    return a / gcd(a, b) * b
}

func ipow(x, p uint) uint {
    prod := uint(1)
    for p > 0 {
        if p&1 != 0 {
            prod *= x
        }
        p >>= 1
        x *= x
    }
    return prod
}

// Gets the prime decomposition of n.
func getPrimes(n uint) []uint {
    var primes []uint
    for i := uint(2); i <= n; i++ {
        div := n / i
        mod := n % i
        for mod == 0 {
            primes = append(primes, i)
            n = div
            div = n / i
            mod = n % i
        }
    }
    return primes
}

// OK for 'small' numbers.
func isPrime(n uint) bool {
    switch {
    case n < 2:
        return false
    case n%2 == 0:
        return n == 2
    case n%3 == 0:
        return n == 3
    default:
        d := uint(5)
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

// Calculates the Pisano period of 'm' from first principles.
func pisanoPeriod(m uint) uint {
    var p, c uint = 0, 1
    for i := uint(0); i < m*m; i++ {
        p, c = c, (p+c)%m
        if p == 0 && c == 1 {
            return i + 1
        }
    }
    return 1
}

// Calculates the Pisano period of p^k where 'p' is prime and 'k' is a positive integer.
func pisanoPrime(p uint, k uint) uint {
    if !isPrime(p) || k == 0 {
        return 0 // can't do this one
    }
    return ipow(p, k-1) * pisanoPeriod(p)
}

// Calculates the Pisano period of 'm' using pisanoPrime.
func pisano(m uint) uint {
    primes := getPrimes(m)
    primePowers := make(map[uint]uint)
    for _, p := range primes {
        primePowers[p]++
    }
    var pps []uint
    for k, v := range primePowers {
        pps = append(pps, pisanoPrime(k, v))
    }
    if len(pps) == 0 {
        return 1
    }
    if len(pps) == 1 {
        return pps[0]
    }
    f := pps[0]
    for i := 1; i < len(pps); i++ {
        f = lcm(f, pps[i])
    }
    return f
}

func main() {
    for p := uint(2); p < 15; p++ {
        pp := pisanoPrime(p, 2)
        if pp > 0 {
            fmt.Printf("pisanoPrime(%2d: 2) = %d\n", p, pp)
        }
    }
    fmt.Println()
    for p := uint(2); p < 180; p++ {
        pp := pisanoPrime(p, 1)
        if pp > 0 {
            fmt.Printf("pisanoPrime(%3d: 1) = %d\n", p, pp)
        }
    }
    fmt.Println()
    fmt.Println("pisano(n) for integers 'n' from 1 to 180 are:")
    for n := uint(1); n <= 180; n++ {
        fmt.Printf("%3d ", pisano(n))
        if n != 1 && n%15 == 0 {
            fmt.Println()
        }
    }
    fmt.Println()
}
