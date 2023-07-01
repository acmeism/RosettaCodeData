package main

import "fmt"

func gcd(n, k int) int {
    if n < k || k < 1 {
        panic("Need n >= k and k >= 1")
    }

    s := 1
    for n&1 == 0 && k&1 == 0 {
        n >>= 1
        k >>= 1
        s <<= 1
    }

    t := n
    if n&1 != 0 {
        t = -k
    }
    for t != 0 {
        for t&1 == 0 {
            t >>= 1
        }
        if t > 0 {
            n = t
        } else {
            k = -t
        }
        t = n - k
    }
    return n * s
}

func totient(n int) int {
    tot := 0
    for k := 1; k <= n; k++ {
        if gcd(n, k) == 1 {
            tot++
        }
    }
    return tot
}

func main() {
    var perfect []int
    for n := 1; len(perfect) < 20; n += 2 {
        tot := n
        sum := 0
        for tot != 1 {
            tot = totient(tot)
            sum += tot
        }
        if sum == n {
            perfect = append(perfect, n)
        }
    }
    fmt.Println("The first 20 perfect totient numbers are:")
    fmt.Println(perfect)
}
