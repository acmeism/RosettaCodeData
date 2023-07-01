package main

import (
    "fmt"
    "strings"

    "data"
    "datadef"
)

func find(cond func(*datadef.Element) bool) int {
    for i := range data.List {
        if cond(&data.List[i]) {
            return i
        }
    }
    return -1
}

func main() {
    i := find(func(e *datadef.Element) bool {
        return e.Name == "Dar Es Salaam"
    })
    if i < 0 {
        fmt.Println("*** not found ***")
    } else {
        fmt.Println(i)
    }

    i = find(func(e *datadef.Element) bool {
        return e.Population < 5
    })
    if i < 0 {
        fmt.Println("*** not found ***")
    } else {
        fmt.Println(data.List[i].Name)
    }

    i = find(func(e *datadef.Element) bool {
        return strings.HasPrefix(e.Name, "A")
    })
    if i < 0 {
        fmt.Println("*** not found ***")
    } else {
        fmt.Println(data.List[i].Population)
    }
}
