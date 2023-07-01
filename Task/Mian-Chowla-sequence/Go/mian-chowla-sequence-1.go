package main

import "fmt"

func contains(is []int, s int) bool {
    for _, i := range is {
        if s == i {
            return true
        }
    }
    return false
}

func mianChowla(n int) []int {
    mc := make([]int, n)
    mc[0] = 1
    is := []int{2}
    var sum int
    for i := 1; i < n; i++ {
        le := len(is)
    jloop:
        for j := mc[i-1] + 1; ; j++ {
            mc[i] = j
            for k := 0; k <= i; k++ {
                sum = mc[k] + j
                if contains(is, sum) {
                    is = is[0:le]
                    continue jloop
                }
                is = append(is, sum)
            }
            break
        }
    }
    return mc
}

func main() {
    mc := mianChowla(100)
    fmt.Println("The first 30 terms of the Mian-Chowla sequence are:")
    fmt.Println(mc[0:30])
    fmt.Println("\nTerms 91 to 100 of the Mian-Chowla sequence are:")
    fmt.Println(mc[90:100])
}
