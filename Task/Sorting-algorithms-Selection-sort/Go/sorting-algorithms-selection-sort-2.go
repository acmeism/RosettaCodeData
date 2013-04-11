package main

import (
  "sort"
  "fmt"
)

var a = []int{170, 45, 75, -90, -802, 24, 2, 66}

func main() {
    fmt.Println("before:", a)
    selectionSort(sort.IntSlice(a))
    fmt.Println("after: ", a)
}

func selectionSort(a sort.Interface) {
    last := a.Len() - 1
    for i := 0; i < last; i++ {
        iMin := i
        for j := i + 1; j < a.Len(); j++ {
            if a.Less(j, iMin) {
                iMin = j
            }
        }
        a.Swap(i, iMin)
    }
}
