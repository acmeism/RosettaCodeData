package main

import (
    "fmt"
    "log"
    "os"
    "os/exec"
)

func reverseBytes(bytes []byte) {
    for i, j := 0, len(bytes)-1; i < j; i, j = i+1, j-1 {
        bytes[i], bytes[j] = bytes[j], bytes[i]
    }
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    in, err := os.Open("infile.dat")
    check(err)
    defer in.Close()

    out, err := os.Create("outfile.dat")
    check(err)

    record := make([]byte, 80)
    empty := make([]byte, 80)
    for {
        n, err := in.Read(record)
        if err != nil {
            if n == 0 {
                break // EOF reached
            } else {
                out.Close()
                log.Fatal(err)
            }
        }
        reverseBytes(record)
        out.Write(record)
        copy(record, empty)
    }
    out.Close()

    // Run dd from within program to write output.dat
    // to standard output as normal text with newlines.
    cmd := exec.Command("dd", "if=outfile.dat", "cbs=80", "conv=unblock")
    bytes, err := cmd.Output()
    check(err)
    fmt.Println(string(bytes))
}
