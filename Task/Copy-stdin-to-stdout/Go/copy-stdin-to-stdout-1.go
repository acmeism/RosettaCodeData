package main

import (
    "bufio"
    "io"
    "os"
)

func main() {
    r := bufio.NewReader(os.Stdin)
    w := bufio.NewWriter(os.Stdout)
    for {
        b, err := r.ReadByte()
        if err == io.EOF {
            return
        }
        w.WriteByte(b)
        w.Flush()
    }
}
