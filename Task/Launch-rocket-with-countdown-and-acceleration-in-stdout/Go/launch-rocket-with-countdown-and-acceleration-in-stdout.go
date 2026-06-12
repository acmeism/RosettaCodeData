package main

import (
    "fmt"
    "time"
)

const rocket = `
    /\
   (  )
   (  )
  /|/\|\
 /_||||_\
`

func printRocket(above int) {
    fmt.Print(rocket)
    for i := 1; i <= above; i++ {
        fmt.Println("    ||")
    }
}

func cls() {
    fmt.Print("\x1B[2J")
}

func main() {
    // counting
    for n := 5; n >= 1; n-- {
        cls()
        fmt.Printf("%d =>\n", n)
        printRocket(0)
        time.Sleep(time.Second)
    }

    // ignition
    cls()
    fmt.Println("Liftoff !")
    printRocket(1)
    time.Sleep(time.Second)

    // liftoff
    ms := time.Duration(1000)
    for n := 2; n < 100; n++ {
        cls()
        printRocket(n)
        time.Sleep(ms * time.Millisecond)
        if ms >= 40 {
            ms -= 40
        } else {
            ms = 0
        }
    }
}
