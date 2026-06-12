package main

import (
    "encoding/json"
    "log"
    "os"
    "bytes"
    "errors"
    "strings"
)

// structure of test file, generated and then used as input.
type s1 struct {
    A string
    B string
    C int
    D string
}

// structure of output file
type s2 struct {
    A string
    C intString // it's a string, but unmarshals from a JSON int.
    X string
}

type intString string

func (i *intString) UnmarshalJSON(b []byte) error {
    if len(b) == 0 || bytes.IndexByte([]byte("0123456789-"), b[0]) < 0 {
        return errors.New("Unmarshal intString expected JSON number")
    }
    *i = intString(b)
    return nil
}

// "constructor" initializes X
func NewS2() *s2 {
    return &s2{X: "XXXXX"}
}

func main() {
    // generate test file
    o1, err := os.Create("o1.json")
    if err != nil {
        log.Fatal(err)
    }
    e := json.NewEncoder(o1)
    for i := 1; i <= 5; i++ {
        err := e.Encode(s1{
            strings.Repeat("A", i),
            strings.Repeat("B", i),
            i,
            strings.Repeat("D", i),
        })
        if err != nil {
            log.Fatal(err)
        }
    }
    o1.Close()

    // reopen the test file, also open output file
    in, err := os.Open("o1.json")
    if err != nil {
        log.Fatal(err)
    }
    out, err := os.Create("out.json")
    if err != nil {
        log.Fatal(err)
    }
    // copy input to output, streaming
    d := json.NewDecoder(in)
    e = json.NewEncoder(out)
    for d.More() {
        // a little different than the PL/I example.  PL/I reads into s1, then
        // does the selective copy in memory.  The Go JSON reader can read the
        // s1 formated JSON directly into the s2 Go struct without needing any
        // intermediate s1 struct.
        s := NewS2()
        if err = d.Decode(s); err != nil {
            log.Fatal(err)
        }
        if err = e.Encode(s); err != nil {
            log.Fatal(err)
        }
    }
}
