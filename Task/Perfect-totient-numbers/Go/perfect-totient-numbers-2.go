package main

import "fmt"

func totient(n int) int {
    tot := n
    for i := 2; i*i <= n; i += 2 {
        if n%i == 0 {
            for n%i == 0 {
                n /= i
            }
            tot -= tot / i
        }
        if i == 2 {
            i = 1
        }
    }
    if n > 1 {
        tot -= tot / n
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
