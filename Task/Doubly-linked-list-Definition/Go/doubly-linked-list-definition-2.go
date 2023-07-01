package main

import "fmt"
import "container/list"

func main() {
        // Create a new list and put some values in it.
        l := list.New()
        e4 := l.PushBack(4)
        e1 := l.PushFront(1)
        l.InsertBefore(3, e4)
        l.InsertAfter("two", e1)

        // Iterate through list and print its contents.
        for e := l.Front(); e != nil; e = e.Next() {
            fmt.Println(e.Value)
        }
}
