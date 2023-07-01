package main

import (
    "encoding/json"
    "fmt"
    "go/build"
    "log"
    "os"
    "path/filepath"

    "datadef"
)

func main() {
    var l datadef.List
    if err := json.NewDecoder(os.Stdin).Decode(&l); err != nil {
        log.Fatal(err)
    }
    pp := filepath.Join(filepath.SplitList(build.Default.GOPATH)[0], "src/data")
    f, err := os.Create(filepath.Join(pp, "data.go"))
    if err != nil {
        log.Fatal(err)
    }
    fmt.Fprintln(f, `package data

import "datadef"

var List = datadef.List {`)
    for i, e := range l {
        fmt.Fprintf(f, "   %d: {%q, %g},\n", i, e.Name, e.Population)
    }
    fmt.Fprintln(f, "}")
}
