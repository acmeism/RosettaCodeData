package main

import (
    "fmt"
    "unsafe"
)

func main() {
    myVar := 3.14
    myPointer := &myVar
    fmt.Println(myPointer)
    fmt.Printf("%p\n", myPointer)

    addr := int64(uintptr(unsafe.Pointer(myPointer)))
    fmt.Printf("0x%x\n", addr)
}
