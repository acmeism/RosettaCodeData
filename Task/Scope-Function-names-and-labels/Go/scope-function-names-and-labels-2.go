package ex

import (
    "fmt"
    "runtime"
)

// X is exported.
func X(x func()) {
    pc, _, _, _ := runtime.Caller(0)
    fmt.Println(runtime.FuncForPC(pc).Name(), "calling argument x...")
    x()
}

func x() { // not exported, x not upper case.
    panic("top level x")
}
