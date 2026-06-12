package main

import "fmt"

func main() {
    list1 := [9]int{1, 2, 3, 4, 5, 6, 7, 8, 9}
    list2 := [9]int{10, 11, 12, 13, 14, 15, 16, 17, 18}
    list3 := [9]int{19, 20, 21, 22, 23, 24, 25, 26, 27}
    var list [9]int
    for i := 0; i < 9; i++ {
        list[i] = list1[i]*1e4 + list2[i]*1e2 + list3[i]
    }
    fmt.Println(list)
}
