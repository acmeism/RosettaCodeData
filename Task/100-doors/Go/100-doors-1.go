package main

import "fmt"

func main() {
    doors := [100]bool{}

    // the 100 passes called for in the task description
    for pass := 1; pass <= 100; pass++ {
        for door := pass-1; door < 100; door += pass {
            doors[door] = !doors[door]
        }
    }

    // one more pass to answer the question
    for i, v := range doors {
        if v {
            fmt.Print("1")
        } else {
            fmt.Print("0")
        }

        if i%10 == 9 {
            fmt.Print("\n")
        } else {
            fmt.Print(" ")
        }

    }
}
