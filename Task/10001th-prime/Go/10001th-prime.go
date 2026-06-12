package main

import "fmt"

func isPrime(n int) bool {
    if n == 1 {
        return false
    }
    i := 2
    for i*i <= n {
        if n%i == 0 {
            return false
        }
        i++
    }
    return true
}

func main() {
    var final, pNum int

    for i := 1; pNum < 10001; i++ {
        if isPrime(i) {
            pNum++
        }
        final = i
    }
    fmt.Println(final)
}
