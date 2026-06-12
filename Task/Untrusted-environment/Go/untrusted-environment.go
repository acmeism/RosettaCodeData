package main

import (
    "fmt"
    "reflect"
    "unsafe"
)

func main() {
    bs := []byte("Hello world!")
    fmt.Println(string(bs))
    g := "globe"
    hdr := (*reflect.SliceHeader)(unsafe.Pointer(&bs))
    for i := 0; i < 5; i++ {
        data := (*byte)(unsafe.Pointer(hdr.Data + uintptr(i) + 6))
        *data = g[i]
    }
    fmt.Println(string(bs))
}
