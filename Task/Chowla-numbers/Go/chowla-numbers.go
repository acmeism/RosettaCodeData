package main

import "fmt"

func chowla(n int) int {
    if n < 1 {
        panic("argument must be a positive integer")
    }
    sum := 0
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            j := n / i
            if i == j {
                sum += i
            } else {
                sum += i + j
            }
        }
    }
    return sum
}

func sieve(limit int) []bool {
    // True denotes composite, false denotes prime.
    // Only interested in odd numbers >= 3
    c := make([]bool, limit)
    for i := 3; i*3 < limit; i += 2 {
        if !c[i] && chowla(i) == 0 {
            for j := 3 * i; j < limit; j += 2 * i {
                c[j] = true
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
    for i := 1; i <= 37; i++ {
        fmt.Printf("chowla(%2d) = %d\n", i, chowla(i))
    }
    fmt.Println()

    count := 1
    limit := int(1e7)
    c := sieve(limit)
    power := 100
    for i := 3; i < limit; i += 2 {
        if !c[i] {
            count++
        }
        if i == power-1 {
            fmt.Printf("Count of primes up to %-10s = %s\n", commatize(power), commatize(count))
            power *= 10
        }
    }

    fmt.Println()
    count = 0
    limit = 35000000
    for i := uint(2); ; i++ {
        p := 1 << (i - 1) * (1<<i - 1) // perfect numbers must be of this form
        if p > limit {
            break
        }
        if chowla(p) == p-1 {
            fmt.Printf("%s is a perfect number\n", commatize(p))
            count++
        }
    }
    fmt.Println("There are", count, "perfect numbers <= 35,000,000")
}
