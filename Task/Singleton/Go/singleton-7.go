package main

import (
    "log"
    "math/rand"
    "time"

    "blue"
    "red"
    "single"
)

func main() {
    rand.Seed(time.Now().Unix())
    switch rand.Intn(3) {
    case 1:
        red.SetColor()
        blue.SetColor()
    case 2:
        blue.SetColor()
        red.SetColor()
    }
    log.Println(single.Color())
}
