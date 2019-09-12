package main

import "fmt"

var count = 0

func foo() {
    fmt.Println("foo called")
}

func init() {
    fmt.Println("first init called")
    foo()
}

func init() {
    fmt.Println("second init called")
    main()
}

func main() {
    count++
    fmt.Println("main called when count is", count)
}
