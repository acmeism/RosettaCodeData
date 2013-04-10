package main

import (
    "ddate"
    "fmt"
    "os"
    "strings"
    "time"
)

func main() {
    pi := 1
    fnord := ddate.DefaultFmt
    if len(os.Args) > 1 {
        switch os.Args[1][0] {
        case '+':
            pi++
            fnord = os.Args[1][1:]
        case '-':
            usage()
        }
    }
    var eris time.Time
    switch len(os.Args) - pi {
    case 0:
        eris = time.Now()
    case 3:
        var err error
        eris, err = time.Parse("2 1 2006", strings.Join(os.Args[pi:pi+3], " "))
        if err != nil {
            fmt.Println(err)
            usage()
        }
    default:
        usage()
    }
    fmt.Println(ddate.New(eris).Format(fnord))
}

func usage() {
    fmt.Fprintf(os.Stderr, "usage: %s [+format] [day month year]\n", os.Args[0])
    os.Exit(1)
}
