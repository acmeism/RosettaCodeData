package main

import "fmt"

func main() {
    a := []int{170, 45, 75, -90, -802, 24, 2, 66}
    fmt.Println("before:", a)
    combSort(a)
    fmt.Println("after: ", a)
}

func combSort(a []int) {
    if len(a) < 2 {
        return
    }
    for gap := len(a); ; {
        if gap > 1 {
            gap = gap * 4 / 5
        }
        swapped := false
        for i := 0; ; {
            if a[i] > a[i+gap] {
                a[i], a[i+gap] = a[i+gap], a[i]
                swapped = true
            }
            i++
            if i+gap >= len(a) {
                break
            }
        }
        if gap == 1 && !swapped {
            break
        }
    }
}
