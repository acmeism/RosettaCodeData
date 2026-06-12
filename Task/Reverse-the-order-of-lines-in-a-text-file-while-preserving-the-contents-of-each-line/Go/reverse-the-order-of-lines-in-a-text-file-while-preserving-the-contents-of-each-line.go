package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "runtime"
)

func main() {
    fileName1 := "rodgers.txt"
    fileName2 := "rodgers_reversed.txt"
    lineBreak := "\n"
    if runtime.GOOS == "windows" {
        lineBreak = "\r\n"
    }
    // read lines from input file
    b, err := ioutil.ReadFile(fileName1)
    if err != nil {
        log.Fatal(err)
    }
    lines := bytes.Split(b, []byte(lineBreak))
    // remove final blank line, if any, added by some editors
    if len(lines[len(lines)-1]) == 0 {
        lines = lines[:len(lines)-1]
    }

    // write lines in reverse order to output file
    for i, j := 0, len(lines)-1; i < j; i, j = i+1, j-1 {
        lines[i], lines[j] = lines[j], lines[i]
    }
    b = bytes.Join(lines, []byte(lineBreak))
    if err = ioutil.WriteFile(fileName2, b, 0o666); err != nil {
        log.Fatal(err)
    }
    // print contents of output file to terminal
    b, err = ioutil.ReadFile(fileName2)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(string(b))
}
