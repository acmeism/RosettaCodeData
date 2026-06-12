package main

import (
    "fmt"
)

type any = interface{}

func uselessFunc(uselessParam any) { // parameter required but never used
    if true {
        // do something
    } else {
        fmt.Println("Never called")
    }

    for range []any{} {
        fmt.Println("Never called")
    }

    for false {
        fmt.Println("Never called")
    }

    fmt.Print("") // no visible effect

    return // redundant as function would return 'naturally' anyway
}

type NotCompletelyUseless struct {
    /*
       On the face of it this struct is useless because:
       (1) it has no fields
       (2) there are no associated methods
       (3) there is no inheritance in Go

       However, it's not in fact completely useless because:
       (4) it can be used as a zero length value in a map to emulate a set
    */
}

func main() {
    uselessFunc(0)
    set := make(map[int]NotCompletelyUseless)
    set[0] = NotCompletelyUseless{}
    set[0] = NotCompletelyUseless{} // duplicate key so not added to set
    fmt.Println(set)
}
