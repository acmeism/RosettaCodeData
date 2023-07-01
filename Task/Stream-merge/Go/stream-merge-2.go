package main

import (
    "fmt"
    "io"
    "log"
    "os"
    "strings"

    "fib"
)

var s1 = "3 14 15"
var s2 = "2 17 18"
var s3 = ""
var s4 = "2 3 5 7"

func main() {
    mergeN(
        os.Stdout,
        strings.NewReader(s1),
        strings.NewReader(s2),
        strings.NewReader(s3),
        strings.NewReader(s4))
    fmt.Println()
}

func r1(r io.Reader) (v int, ok bool) {
    switch _, err := fmt.Fscan(r, &v); {
    case err == nil:
        return v, true
    case err != io.EOF:
        log.Fatal(err)
    }
    return
}

type sv struct {
    s io.Reader
    v int
}

func (i sv) LT(j fib.Value) bool { return i.v < j.(sv).v }

func mergeN(m io.Writer, s ...io.Reader) {
    h := &fib.Heap{}
    for _, s := range s {
        if v, d := r1(s); d {
            h.Insert(sv{s, v})
        }
    }
    for h.Node != nil {
        min, _ := h.ExtractMin()
        p := min.(sv)
        fmt.Fprint(m, p.v, " ")
        if v, d := r1(p.s); d {
            h.Insert(sv{p.s, v})
        }
    }
}
