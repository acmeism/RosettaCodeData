package main

import (
    "fmt"
    "runtime"
)

func main() {
    stackTrace := make([]byte, 1024)
    n := runtime.Stack(stackTrace, true)
    stackTrace = stackTrace[:n]
    fmt.Printf("%s\n", stackTrace)
    fmt.Printf("(%d bytes)\n", len(stackTrace))
}
