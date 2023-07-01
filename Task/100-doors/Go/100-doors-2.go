package main

import "fmt"

func main() {
    var door int = 1
    var incrementer = 0

    for current := 1; current <= 100; current++ {
        fmt.Printf("Door %d ", current)

        if current == door {
            fmt.Printf("Open\n")
            incrementer++
            door += 2*incrementer + 1
        } else {
            fmt.Printf("Closed\n")
        }
    }
}
