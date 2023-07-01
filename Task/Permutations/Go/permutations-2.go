package main

import "fmt"

func main() {
        var a = []int{1, 2, 3}
        fmt.Println(a)
        var n = len(a) - 1
        var i, j int
        for c := 1; c < 6; c++ { // 3! = 6:
                i = n - 1
                j = n
                for a[i] > a[i+1] {
                        i--
                }
                for a[j] < a[i] {
                        j--
                }
                a[i], a[j] = a[j], a[i]
                j = n
                i += 1
                for i < j {
                        a[i], a[j] = a[j], a[i]
                        i++
                        j--
                }
                fmt.Println(a)
        }
}
