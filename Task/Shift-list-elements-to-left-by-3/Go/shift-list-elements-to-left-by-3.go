package main

import "fmt"

// in place left shift by 1
func lshift(l []int) {
    n := len(l)
    if n < 2 {
        return
    }
    f := l[0]
    for i := 0; i < n-1; i++ {
        l[i] = l[i+1]
    }
    l[n-1] = f
}

func main() {
    l := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}
    fmt.Println("Original list     :", l)
    for i := 0; i < 3; i++ {
        lshift(l)
    }
    fmt.Println("Shifted left by 3 :", l)
}
