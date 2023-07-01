package main

import (
    "bufio"
    "fmt"
    "io"
    "os"
)

func Runer(r io.RuneReader) func() (rune, error) {
    return func() (r rune, err error) {
        r, _, err = r.ReadRune()
        return
    }
}

func main() {
    runes := Runer(bufio.NewReader(os.Stdin))
    for r, err := runes(); err != nil; r,err = runes() {
        fmt.Printf("%c", r)
    }
}
