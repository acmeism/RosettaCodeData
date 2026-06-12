package main

import (
    "fmt"
    "rcu"
)

func main() {
    numbers1 := [5]int{5, 45, 23, 21, 67}
    numbers2 := [5]int{43, 22, 78, 46, 38}
    numbers3 := [5]int{9, 98, 12, 98, 53}
    numbers := [5]int{}
    for n := 0; n < 5; n++ {
        numbers[n] = rcu.Min(rcu.Min(numbers1[n], numbers2[n]), numbers3[n])
    }
    fmt.Println(numbers)
}
