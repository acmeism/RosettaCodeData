package main

import (
    "bufio"
    "fmt"
    "io"
    "log"
    "os"
)

func main() {
    f, err := os.Open("file")
    if err != nil {
        log.Fatal(err)
    }
    bf := bufio.NewReader(f)
    for {
        switch line, err := bf.ReadString('\n'); err {
        case nil:
            // valid line, echo it.  note that line contains trailing \n.
            fmt.Print(line)
        case io.EOF:
            if line > "" {
                // last line of file missing \n, but still valid
                fmt.Println(line)
            }
            return
        default:
            log.Fatal(err)
        }
    }
}
