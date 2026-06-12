package main

import (
    "fmt"
    "sort"
)

func main() {
    a := []int{6, 81, 243, 14, 25, 49, 123, 69, 11}
    for len(a) > 1 {
        sort.Ints(a)
        fmt.Println("Sorted list:", a)
        sum := a[0] + a[1]
        fmt.Printf("Two smallest: %d + %d = %d\n", a[0], a[1], sum)
        a = append(a, sum)
        a = a[2:]
    }
    fmt.Println("Last item is", a[0], "\b.")
}
