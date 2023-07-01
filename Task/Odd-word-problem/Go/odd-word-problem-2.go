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

func owp(dst io.Writer, src io.Reader) {
    byte_in := func () byte {
        bs := make([]byte, 1)
        src.Read(bs)
        return bs[0]
    }
    byte_out := func (b byte) { dst.Write([]byte{b}) }
    odd := func() byte {
        for {
            b := byte_in()
            if unicode.IsPunct(int(b)) {
                return b
            }
            defer byte_out(b)
        }
        panic("impossible")
    }
    for {
        for {
            b := byte_in()
            byte_out(b)
            if b == '.' {
                return
            }
            if unicode.IsPunct(rune(b)) {
                break
            }
        }
        b := odd()
        byte_out(b)
        if b == '.' {
            return
        }
    }
}
