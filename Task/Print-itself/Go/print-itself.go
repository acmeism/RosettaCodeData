package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "os"
    "path"
)

func main() {
    self := path.Base(os.Args[0]) + ".go"
    bytes, err := ioutil.ReadFile(self)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Print(string(bytes))
}
