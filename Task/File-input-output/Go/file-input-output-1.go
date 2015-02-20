package main

import (
    "fmt"
    "io/ioutil"
)

func main() {
    b, err := ioutil.ReadFile("input.txt")
    if err != nil {
        fmt.Println(err)
        return
    }
    if err = ioutil.WriteFile("output.txt", b, 0666); err != nil {
        fmt.Println(err)
    }
}
