package main

import (
    "bufio"
    "fmt"
    "io"
    "log"
    "os"
)

func main() {
    f, err := os.Open("file") // os.OpenFile has more options if you need them
    if err != nil {           // error checking is good practice
        // error *handling* is good practice.  log.Fatal sends the error
        // message to stderr and exits with a non-zero code.
        log.Fatal(err)
    }

    // os.File has no special buffering, it makes straight operating system
    // requests.  bufio.Reader does buffering and has several useful methods.
    bf := bufio.NewReader(f)

    // there are a few possible loop termination
    // conditions, so just start with an infinite loop.
    for {
        // reader.ReadLine does a buffered read up to a line terminator,
        // handles either /n or /r/n, and returns just the line without
        // the /r or /r/n.
        line, isPrefix, err := bf.ReadLine()

        // loop termination condition 1:  EOF.
        // this is the normal loop termination condition.
        if err == io.EOF {
            break
        }

        // loop termination condition 2: some other error.
        // Errors happen, so check for them and do something with them.
        if err != nil {
            log.Fatal(err)
        }

        // loop termination condition 3: line too long to fit in buffer
        // without multiple reads.  Bufio's default buffer size is 4K.
        // Chances are if you haven't seen a line terminator after 4k
        // you're either reading the wrong file or the file is corrupt.
        if isPrefix {
            log.Fatal("Error: Unexpected long line reading", f.Name())
        }

        // success.  The variable line is now a byte slice based on on
        // bufio's underlying buffer.  This is the minimal churn necessary
        // to let you look at it, but note! the data may be overwritten or
        // otherwise invalidated on the next read.  Look at it and decide
        // if you want to keep it.  If so, copy it or copy the portions
        // you want before iterating in this loop.  Also note, it is a byte
        // slice.  Often you will want to work on the data as a string,
        // and the string type conversion (shown here) allocates a copy of
        // the data.  It would be safe to send, store, reference, or otherwise
        // hold on to this string, then continue iterating in this loop.
        fmt.Println(string(line))
    }
}
