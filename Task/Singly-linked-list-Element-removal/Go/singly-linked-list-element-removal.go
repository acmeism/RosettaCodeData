package main

import "fmt"

type Ele struct {
    Data interface{}
    Next *Ele
}

var head *Ele

func (e *Ele) Append(data interface{}) *Ele {
    if e == nil {
        return e
    }
    if e.Next == nil {
        e.Next = &Ele{data, nil}
    } else {
        e.Next = &Ele{data, e.Next}
    }
    return e.Next
}

// Removes first element with given data value from the list.
// If this is 'head' element, resets 'head' to next element.
// Does nothing if data value is not present.
func (e *Ele) Remove(data interface{}) {
    if e == nil {
        return
    }
    if e.Data == data {
        if e == head {
            head = e.Next
        }
        e.Next = nil
        return
    }
    prev := e
    for iter := e.Next; iter != nil; iter = iter.Next {
        if iter.Data == data {
            prev.Next = iter.Next
            iter.Next = nil
            return
        }
        prev = iter
    }
}

func (e *Ele) String() string {
    return fmt.Sprintf("%v", e.Data)
}

func (e *Ele) Traverse() {
    if e == nil {
        fmt.Println(e)
        return
    }
    for iter := e; iter != nil; iter = iter.Next {
        fmt.Println(iter)
    }
}

func main() {
    head = &Ele{"tacos", nil}
    next := head.Append("burritos")
    next = next.Append("fajitas")
    next = next.Append("enchilatas")

    fmt.Println("Before any removals:")
    head.Traverse()

    head.Remove("fajitas")
    fmt.Println("\nAfter removing fajitas:")
    head.Traverse()

    head.Remove("tacos")
    fmt.Println("\nAfter removing tacos:")
    head.Traverse()

    head.Remove("enchilatas")
    fmt.Println("\nAfter removing enchilatas:")
    head.Traverse()

    head.Remove("burritos")
    fmt.Println("\nAfter removing burritos:")
    head.Traverse()
}
