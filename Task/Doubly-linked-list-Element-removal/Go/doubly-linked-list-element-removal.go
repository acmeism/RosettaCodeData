package main

import (
    "container/list"
    "fmt"
)

func printDll(s string, dll *list.List) {
    fmt.Printf("%s: { ", s)
    for e := dll.Front(); e != nil; e = e.Next() {
        fmt.Printf("%v ", e.Value)
    }
    fmt.Println("}")
}

func main() {
    dll := list.New()
    e1 := dll.PushBack("dog")
    e2 := dll.PushBack("cat")
    dll.PushBack("bear")
    printDll("Before removals", dll)
    dll.Remove(e2) // remove "cat"
    printDll("After removal 1", dll)
    dll.Remove(e1) // remove "dog"
    printDll("After removal 2", dll)
}
