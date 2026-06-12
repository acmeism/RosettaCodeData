package main

import (
    "flag"
    "fmt"
)

func main() {
    b := flag.Bool("b", false, "just a boolean")
    s := flag.String("s", "", "any ol' string")
    n := flag.Int("n", 0, "your lucky number")
    flag.Parse()
    fmt.Println("b:", *b)
    fmt.Println("s:", *s)
    fmt.Println("n:", *n)
}
