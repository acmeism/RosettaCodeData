package main

import (
  "sort"
  "fmt"
)

func main() {
    a := []int{170, 45, 75, -90, -802, 24, 2, 66}
    fmt.Println("before:", a)
    gnomeSort(sort.IntSlice(a))
    fmt.Println("after: ", a)
}

func gnomeSort(a sort.Interface) {
    for i, j := 1, 2; i < a.Len(); {
        if a.Less(i, i-1) {
            a.Swap(i-1, i)
            i--
            if i > 0 {
                continue
            }
        }
        i = j
        j++
    }
}
