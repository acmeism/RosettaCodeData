package main

import "fmt"

type Outer struct {
    field int
    Inner struct {
        field int
    }
}

func (o *Outer) outerMethod() {
    fmt.Println("Outer's field has a value of", o.field)
}

func (o *Outer) innerMethod() {
    fmt.Println("Inner's field has a value of", o.Inner.field)
}

func main() {
    o := &Outer{field: 43}
    o.Inner.field = 42
    o.innerMethod()
    o.outerMethod()
    /* alternative but verbose way of instantiating */
    p := &Outer{
        field: 45,
        Inner: struct {
            field int
        }{
            field: 44,
        },
    }
    p.innerMethod()
    p.outerMethod()
}
