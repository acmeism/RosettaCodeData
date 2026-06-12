package main

import "fmt"

func findMin(a []int) (int, int) {
    ix := 0
    min := a[0]
    for i := 1; i < len(a); i++ {
        if a[i] < min {
            ix = i
            min = a[i]
        }
    }
    return min, ix
}

func main() {
    a := []int{6, 81, 243, 14, 25, 49, 123, 69, 11}
    for len(a) > 1 {
        fmt.Println("List:", a)
        var s [2]int
        for i := 0; i < 2; i++ {
            min, ix := findMin(a)
            s[i] = min
            a = append(a[:ix], a[ix+1:]...)
        }
        sum := s[0] + s[1]
        fmt.Printf("Two smallest: %d + %d = %d\n", s[0], s[1], sum)
        a = append(a, sum)
    }
    fmt.Println("Last item is", a[0], "\b.")
}
