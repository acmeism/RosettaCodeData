package main

import "fmt"

type Ctrl int

const (
    nul Ctrl = iota
    soh
    stx
    etx
    eot
    enq
    ack
    bel
    bs
    ht
    lf
    vt
    ff
    cr
    so
    si
    dle
    dc1
    dc2
    dc3
    dc4
    nak
    syn
    etb
    can
    em
    sub
    esc
    fs
    gs
    rs
    us
    space
    del = 127
)

func main() {
    // print some specimen values
    fmt.Println(cr)
    fmt.Println(del)
}
