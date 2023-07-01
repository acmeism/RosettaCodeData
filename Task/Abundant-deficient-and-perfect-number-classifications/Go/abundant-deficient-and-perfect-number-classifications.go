package main

import "fmt"

func pfacSum(i int) int {
    sum := 0
    for p := 1; p <= i/2; p++ {
        if i%p == 0 {
            sum += p
        }
    }
    return sum
}

func main() {
    var d, a, p = 0, 0, 0
    for i := 1; i <= 20000; i++ {
        j := pfacSum(i)
        if j < i {
            d++
        } else if j == i {
            p++
        } else {
            a++
        }
    }
    fmt.Printf("There are %d deficient numbers between 1 and 20000\n", d)
    fmt.Printf("There are %d abundant numbers  between 1 and 20000\n", a)
    fmt.Printf("There are %d perfect numbers between 1 and 20000\n", p)
}
