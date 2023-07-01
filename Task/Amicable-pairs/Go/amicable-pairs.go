package main

import "fmt"

func pfacSum(i int) int {
    sum := 0
    for p := 1; p <= i/2; p++ {
        if i%p == 0 {
            sum += p
        }
    }
    return sum
}

func main() {
    var a[20000]int
    for i := 1; i < 20000; i++ {
        a[i] = pfacSum(i)
    }
    fmt.Println("The amicable pairs below 20,000 are:")
    for n := 2; n < 19999; n++ {
        m := a[n]
        if m > n && m < 20000 && n == a[m] {
            fmt.Printf("  %5d and %5d\n", n, m)
        }
    }
}
