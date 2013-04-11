package main

import (
  "fmt"
  "sort"
)

func insertionSort(a sort.Interface) {
    for i := 1; i < a.Len(); i++ {
        for j := i; j > 0 && a.Less(j, j-1); j-- {
            a.Swap(j-1, j)
        }
    }
}

func main() {
    list := []int{31, 41, 59, 26, 53, 58, 97, 93, 23, 84}
    fmt.Println("unsorted:", list)

    insertionSort(sort.IntSlice(list))
    fmt.Println("sorted!  ", list)
}
