package main

import "fmt"

func countDivisors(n int) int {
    count := 0
    i := 1
    k := 2
    if n%2 == 0 {
        k = 1
    }
    for i*i <= n {
        if n%i == 0 {
            count++
            j := n / i
            if j != i {
                count++
            }
        }
        i += k
    }
    return count
}

func main() {
    fmt.Println("The first 100 tau numbers are:")
    count := 0
    i := 1
    for count < 100 {
        tf := countDivisors(i)
        if i%tf == 0 {
            fmt.Printf("%4d  ", i)
            count++
            if count%10 == 0 {
                fmt.Println()
            }
        }
        i++
    }
}
