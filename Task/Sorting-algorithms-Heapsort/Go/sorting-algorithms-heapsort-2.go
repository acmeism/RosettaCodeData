package main

import (
  "sort"
  "fmt"
)

func main() {
    a := []int{170, 45, 75, -90, -802, 24, 2, 66}
    fmt.Println("before:", a)
    heapSort(sort.IntSlice(a))
    fmt.Println("after: ", a)
}

func heapSort(a sort.Interface) {
    for start := (a.Len() - 2) / 2; start >= 0; start-- {
        siftDown(a, start, a.Len()-1)
    }
    for end := a.Len() - 1; end > 0; end-- {
        a.Swap(0, end)
        siftDown(a, 0, end-1)
    }
}


func siftDown(a sort.Interface, start, end int) {
    for root := start; root*2+1 <= end; {
        child := root*2 + 1
        if child+1 <= end && a.Less(child, child+1) {
            child++
        }
        if !a.Less(root, child) {
            return
        }
        a.Swap(root, child)
        root = child
    }
}
