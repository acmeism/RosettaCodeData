package main

import "fmt"

func main() {
    outer:
    for i := 0; i < 4; i++ {
        for j := 0; j < 4; j++ {
            if i + j == 4 { continue outer }
            if i + j == 5 { break outer }
            fmt.Println(i + j)
        }
    }

    k := 3
    if k == 3 { goto later }
    fmt.Println(k)  // never executed
    later:
    k++
    fmt.Println(k)
}
