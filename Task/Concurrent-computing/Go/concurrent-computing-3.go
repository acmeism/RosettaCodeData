package main

import "fmt"

func main() {
    w1 := make(chan bool, 1)
    w2 := make(chan bool, 1)
    w3 := make(chan bool, 1)
    for i := 0; i < 3; i++ {
        w1 <- true
        w2 <- true
        w3 <- true
        fmt.Println()
        for i := 0; i < 3; i++ {
            select {
            case <-w1:
                fmt.Println("Enjoy")
            case <-w2:
                fmt.Println("Rosetta")
            case <-w3:
                fmt.Println("Code")
            }
        }
    }
}
