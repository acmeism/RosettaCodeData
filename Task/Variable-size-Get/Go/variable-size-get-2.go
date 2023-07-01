package main

import (
    "fmt"
    "reflect"
    "runtime"
    "unsafe"
)

func main() {
    // unsafe.Sizeof returns the size in bytes.
    var i int
    fmt.Println(unsafe.Sizeof(i))
    // The size returned is that of the top level object and does not
    // include any referenced data.  A type like string always returns
    // the same number, the size of the string header.
    fmt.Println(unsafe.Sizeof("Rosetta"))
    fmt.Println(unsafe.Sizeof("Code"))
    // For some untrusted environments, package unsafe is not available
    // but reflect is.  The Size method of a type will return the same value
    // as unsafe.Sizeof.
    fmt.Println(reflect.TypeOf("Cod").Size())
    // Some sizes are implementation dependent.
    fmt.Println(runtime.Version(), runtime.GOARCH)
}
