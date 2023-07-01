package main

import "fmt"

type intSlice []int

func (s intSlice) each(f func(int)) {
    for _, i := range s {
        f(i)
    }
}

func (s intSlice) Map(f func(int) int) intSlice {
    r := make(intSlice, len(s))
    for j, i := range s {
        r[j] = f(i)
    }
    return r
}

func main() {
    s := intSlice{1, 2, 3, 4, 5}

    s.each(func(i int) {
        fmt.Println(i * i)
    })

    fmt.Println(s.Map(func(i int) int {
        return i * i
    }))
}
