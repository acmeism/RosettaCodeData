package main

import (
    "fmt"
    "reflect"
)

type example struct{}

func (example) Foo() int {
    return 42
}

// a method to call another method by name
func (e example) CallMethod(n string) int {
    if m := reflect.ValueOf(e).MethodByName(n); m.IsValid() {
        // it's known.  call it.
        return int(m.Call(nil)[0].Int())
    }
    // otherwise it's unknown.  handle as needed.
    fmt.Println("Unknown method:", n)
    return 0
}

func main() {
    var e example
    fmt.Println(e.CallMethod("Foo"))
    fmt.Println(e.CallMethod("Bar"))
}
