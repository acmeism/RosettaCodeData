package main

import "fmt"

func main() {
    const max = 1000
    a := make([]int, max) // all zero by default
    seen := make(map[int]int)
    for n := 0; n < max-1; n++ {
        if m, ok := seen[a[n]]; ok {
            a[n+1] = n - m
        }
        seen[a[n]] = n
    }
    fmt.Println("The first ten terms of the Van Eck sequence are:")
    fmt.Println(a[:10])
    fmt.Println("\nTerms 991 to 1000 of the sequence are:")
    fmt.Println(a[990:])
}
