package main

import (
  "sort"
  "fmt"
)

func main() {
    a := []int{170, 45, 75, -90, -802, 24, 2, 66}
    fmt.Println("before:", a)
    combSort(sort.IntSlice(a))
    fmt.Println("after: ", a)
}

func combSort(a sort.Interface) {
    if a.Len() < 2 {
        return
    }
    for gap := a.Len(); ; {
        if gap > 1 {
            gap = gap * 4 / 5
        }
        swapped := false
        for i := 0; ; {
            if a.Less(i+gap, i) {
                a.Swap(i, i+gap)
                swapped = true
            }
            i++
            if i+gap >= a.Len() {
                break
            }
        }
        if gap == 1 && !swapped {
            break
        }
    }
}
