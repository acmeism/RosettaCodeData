package main

import "fmt"

func kPrime(n, k int) bool {
    nf := 0
    for i := 2; i <= n; i++ {
        for n%i == 0 {
            if nf == k {
                return false
            }
            nf++
            n /= i
        }
    }
    return nf == k
}

func gen(k, n int) []int {
    r := make([]int, n)
    n = 2
    for i := range r {
        for !kPrime(n, k) {
            n++
        }
        r[i] = n
        n++
    }
    return r
}

func main() {
    for k := 1; k <= 5; k++ {
        fmt.Println(k, gen(k, 10))
    }
}
