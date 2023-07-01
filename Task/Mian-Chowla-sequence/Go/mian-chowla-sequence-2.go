package main

import "fmt"

type set map[int]bool

func mianChowla(n int) []int {
    mc := make([]int, n)
    mc[0] = 1
    is := make(set, n*(n+1)/2)
    is[2] = true
    var sum int
    isx := make([]int, 0, n)
    for i := 1; i < n; i++ {
        isx = isx[:0]
    jloop:
        for j := mc[i-1] + 1; ; j++ {
            mc[i] = j
            for k := 0; k <= i; k++ {
                sum = mc[k] + j
                if is[sum] {
                    isx = isx[:0]
                    continue jloop
                }
                isx = append(isx, sum)
            }
            for _, x := range isx {
                is[x] = true
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
