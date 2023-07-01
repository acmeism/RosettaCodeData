package main

import (
  "sort"
  "fmt"
)

func main() {
    a := []int{170, 45, 75, -90, -802, 24, 2, 66}
    fmt.Println("before:", a)
    cocktailSort(sort.IntSlice(a))
    fmt.Println("after: ", a)
}

func cocktailSort(a sort.Interface) {
    last := a.Len() - 1
    for {
        swapped := false
        for i := 0; i < last; i++ {
            if a.Less(i+1, i) {
                a.Swap(i, i+1)
                swapped = true
            }
        }
        if !swapped {
            return
        }
        swapped = false
        for i := last - 1; i >= 0; i-- {
            if a.Less(i+1, i) {
                a.Swap(i, i+1)
                swapped = true
            }
        }
        if !swapped {
            return
        }
    }
}
