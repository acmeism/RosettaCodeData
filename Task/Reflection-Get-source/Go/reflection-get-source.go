package main

import (
    "fmt"
    "path"
    "reflect"
    "runtime"
)

func someFunc() {
    fmt.Println("someFunc called")
}

func main() {
    pc := reflect.ValueOf(someFunc).Pointer()
    f := runtime.FuncForPC(pc)
    name := f.Name()
    file, line := f.FileLine(pc)
    fmt.Println("Name of function :", name)
    fmt.Println("Name of file     :", path.Base(file))
    fmt.Println("Line number      :", line)
}
