package main

import "fmt"

func main() {
    a := []int{170, 45, 75, -90, -802, 24, 2, 66}
    fmt.Println("before:", a)
    gnomeSort(a)
    fmt.Println("after: ", a)
}

func gnomeSort(a []int) {
    for i, j := 1, 2; i < len(a); {
        if a[i-1] > a[i] {
            a[i-1], a[i] = a[i], a[i-1]
            i--
            if i > 0 {
                continue
            }
        }
        i = j
        j++
    }
}
