package main

import "fmt"

func main() {
    a := []int{170, 45, 75, -90, -802, 24, 2, 66}
    fmt.Println("before:", a)
    cocktailSort(a)
    fmt.Println("after: ", a)
}

func cocktailSort(a []int) {
    last := len(a) - 1
    for {
        swapped := false
        for i := 0; i < last; i++ {
            if a[i] > a[i+1] {
                a[i], a[i+1] = a[i+1], a[i]
                swapped = true
            }
        }
        if !swapped {
            return
        }
        swapped = false
        for i := last - 1; i >= 0; i-- {
            if a[i] > a[i+1] {
                a[i], a[i+1] = a[i+1], a[i]
                swapped = true
            }
        }
        if !swapped {
            return
        }
    }
}
