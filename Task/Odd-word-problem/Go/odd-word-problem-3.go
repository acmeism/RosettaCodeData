package main

import (
    "bytes"
    "fmt"
    "io"
    "os"
    "unicode"
)

func main() {
    owp(os.Stdout, bytes.NewBufferString("what,is,the;meaning,of:life."))
    fmt.Println()
    owp(os.Stdout, bytes.NewBufferString("we,are;not,in,kansas;any,more."))
    fmt.Println()
}

type Coroutine struct {
    out <-chan Coroutine
    in chan<- byte
}

func owp(dst io.Writer, src io.Reader) {
    byte_in := func () (byte, error) {
        bs := make([]byte, 1)
        _, err := src.Read(bs)
        return bs[0], err
    }
    byte_out := func (b byte) { dst.Write([]byte{b}) }

    var f, r Coroutine

    f = func () Coroutine {
        out := make(chan Coroutine)
	in := make(chan byte)
        var fwd func (byte) byte
        fwd = func (c byte) (z byte) {
            if unicode.IsLetter(rune(c)) {
                byte_out(c)
                out <- f
                z = fwd(<- in)
            } else {
                z = c
            }
            return
        }
        go func () {
            for {
                x, ok := <- in
                if !ok { break }
                byte_out(fwd(x))
                out <- r
            }
        } ()
        return Coroutine{ out, in }
    } ()
    r = func () Coroutine {
        out := make(chan Coroutine)
	in := make(chan byte)
        var rev func (byte) byte
        rev = func (c byte) (z byte) {
            if unicode.IsLetter(rune(c)) {
                out <- r
                z = rev(<- in)
                byte_out(c)
            } else {
                z = c
            }
            return
        }
        go func () {
            for {
                x, ok := <- in
                if !ok { break }
                byte_out(rev(x))
                out <- f
            }
        } ()
        return Coroutine{ out, in }
    } ()

    for coro := f; ; coro = <- coro.out {
        c, err := byte_in()
        if err != nil { break }
        coro.in <- c
    }
    close(f.in)
    close(r.in)
}
