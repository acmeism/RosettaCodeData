package main

import "fmt"

func ulam(n int) int {
    ulams := []int{1, 2}
    set := map[int]bool{1: true, 2: true}
    i := 3
    for {
        count := 0
        for j := 0; j < len(ulams); j++ {
            _, ok := set[i-ulams[j]]
            if ok && ulams[j] != (i-ulams[j]) {
                count++
                if count > 2 {
                    break
                }
            }
        }
        if count == 2 {
            ulams = append(ulams, i)
            set[i] = true
            if len(ulams) == n {
                break
            }
        }
        i++
    }
    return ulams[n-1]
}

func main() {
    for n := 10; n <= 10000; n *= 10 {
        fmt.Println("The", n, "\bth Ulam number is", ulam(n))
    }
}
