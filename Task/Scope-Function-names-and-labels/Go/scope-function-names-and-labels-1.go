package main

import (
    "fmt"
    "runtime"

    "ex"
)

func main() {
    // func nested() { ... not allowed here

    // this is okay, variable f declared and assigned a function literal.
    f := func() {
        // this mess prints the name of the function to show that it's an
        // anonymous function defined in package main
        pc, _, _, _ := runtime.Caller(0)
        fmt.Println(runtime.FuncForPC(pc).Name(), "here!")
    }

    ex.X(f) // function value passed to exported function

    // ex.x() non-exported function not visible here
}
