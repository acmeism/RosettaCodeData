package main

import (
  "fmt"
  "sort"
)

func insertionSort(a []int) {
    for i := 1; i < len(a); i++ {
        value := a[i]
        j := sort.Search(i, func(k int) bool { return a[k] > value })
        copy(a[j+1:i+1], a[j:i])
        a[j] = value
    }
}

func main() {
    list := []int{31, 41, 59, 26, 53, 58, 97, 93, 23, 84}
    fmt.Println("unsorted:", list)

    insertionSort(list)
    fmt.Println("sorted!  ", list)
}
