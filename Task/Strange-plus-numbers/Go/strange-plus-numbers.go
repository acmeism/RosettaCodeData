package main

import "fmt"

func isPrime(n int) bool {
    return n == 2 || n == 3 || n == 5 || n == 7 || n == 11 || n == 13 || n == 17
}

func main() {
    count := 0
    var d []int
    fmt.Println("Strange plus numbers in the open interval (100, 500) are:\n")
    for i := 101; i < 500; i++ {
        d = d[:0]
        j := i
        for j > 0 {
            d = append(d, j%10)
            j /= 10
        }
        if isPrime(d[0]+d[1]) && isPrime(d[1]+d[2]) {
            fmt.Printf("%d ", i)
            count++
            if count%10 == 0 {
                fmt.Println()
            }
        }
    }
    if count%10 != 0 {
        fmt.Println()
    }
    fmt.Printf("\n%d strange plus numbers in all.\n", count)
}
