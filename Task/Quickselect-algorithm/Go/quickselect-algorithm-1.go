package main

import "fmt"

func quickselect(list []int, k int) int {
    for {
        // partition
        px := len(list) / 2
        pv := list[px]
        last := len(list) - 1
        list[px], list[last] = list[last], list[px]
        i := 0
        for j := 0; j < last; j++ {
            if list[j] < pv {
                list[i], list[j] = list[j], list[i]
                i++
            }
        }
        // select
        if i == k {
            return pv
        }
        if k < i {
            list = list[:i]
        } else {
            list[i], list[last] = list[last], list[i]
            list = list[i+1:]
            k -= i + 1
        }
    }
}

func main() {
    for i := 0; ; i++ {
        v := []int{9, 8, 7, 6, 5, 0, 1, 2, 3, 4}
        if i == len(v) {
            return
        }
        fmt.Println(quickselect(v, i))
    }
}
