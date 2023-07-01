package main

import (
    "io"
    "log"
    "os"
)

func CopyFile(out, in string) (err error) {
    var inf, outf *os.File
    inf, err = os.Open(in)
    if err != nil {
        return
    }
    defer func() {
        cErr := inf.Close()
        if err == nil {
            err = cErr
        }
    }()
    outf, err = os.Create(out)
    if err != nil {
        return
    }
    _, err = io.Copy(outf, inf)
    cErr := outf.Close()
    if err == nil {
        err = cErr
    }
    return
}

func main() {
    if err := CopyFile("output.txt", "input.txt"); err != nil {
        log.Fatal(err)
    }
}
