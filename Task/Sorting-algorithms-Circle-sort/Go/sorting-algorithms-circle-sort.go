package main

import "fmt"

func circleSort(a []int, lo, hi, swaps int) int {
    if lo == hi {
        return swaps
    }
    high, low := hi, lo
    mid := (hi - lo) / 2
    for lo < hi {
        if a[lo] > a[hi] {
            a[lo], a[hi] = a[hi], a[lo]
            swaps++
        }
        lo++
        hi--
    }
    if lo == hi {
        if a[lo] > a[hi+1] {
            a[lo], a[hi+1] = a[hi+1], a[lo]
            swaps++
        }
    }
    swaps = circleSort(a, low, low+mid, swaps)
    swaps = circleSort(a, low+mid+1, high, swaps)
    return swaps
}

func main() {
    aa := [][]int{
        {6, 7, 8, 9, 2, 5, 3, 4, 1},
        {2, 14, 4, 6, 8, 1, 3, 5, 7, 11, 0, 13, 12, -1},
    }
    for _, a := range aa {
        fmt.Printf("Original: %v\n", a)
        for circleSort(a, 0, len(a)-1, 0) != 0 {
            // empty block
        }
        fmt.Printf("Sorted  : %v\n\n", a)
    }
}
