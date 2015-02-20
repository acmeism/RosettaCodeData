package main

import "fmt"

func semiprime(n int) bool {
    nf := 0
    for i := 2; i <= n; i++ {
        for n%i == 0 {
            if nf == 2 {
                return false
            }
            nf++
            n /= i
        }
    }
    return nf == 2
}

func main() {
    for v := 1675; v <= 1680; v++ {
        fmt.Println(v, "->", semiprime(v))
    }
}
