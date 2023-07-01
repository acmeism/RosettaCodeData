package main

import (
    "fmt"
    "sort"
    "math/rand"
)

func partition(a sort.Interface, first int, last int, pivotIndex int) int {
    a.Swap(first, pivotIndex) // move it to beginning
    left := first+1
    right := last
    for left <= right {
        for left <= last && a.Less(left, first) {
            left++
        }
        for right >= first && a.Less(first, right) {
            right--
        }
        if left <= right {
            a.Swap(left, right)
            left++
            right--
        }
    }
    a.Swap(first, right) // swap into right place
    return right
}

func quickselect(a sort.Interface, n int) int {
    first := 0
    last := a.Len()-1
    for {
        pivotIndex := partition(a, first, last,
	                        rand.Intn(last - first + 1) + first)
        if n == pivotIndex {
            return pivotIndex
        } else if n < pivotIndex {
            last = pivotIndex-1
        } else {
            first = pivotIndex+1
        }
    }
    panic("bad index")
}

func main() {
    for i := 0; ; i++ {
        v := []int{9, 8, 7, 6, 5, 0, 1, 2, 3, 4}
        if i == len(v) {
            return
        }
        fmt.Println(v[quickselect(sort.IntSlice(v), i)])
    }
}
