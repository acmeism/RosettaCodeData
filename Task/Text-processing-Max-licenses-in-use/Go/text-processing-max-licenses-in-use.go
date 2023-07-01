package main

import (
    "bufio"
    "bytes"
    "fmt"
    "log"
    "os"
)

const (
    filename   = "mlijobs.txt"
    inoutField = 1
    timeField  = 3
    numFields  = 7
)

func main() {
    file, err := os.Open(filename)
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()
    var ml, out int
    var mlTimes []string
    in := []byte("IN")
    s := bufio.NewScanner(file)
    for s.Scan() {
        f := bytes.Fields(s.Bytes())
        if len(f) != numFields {
            log.Fatal("unexpected format,", len(f), "fields.")
        }
        if bytes.Equal(f[inoutField], in) {
            out--
            if out < 0 {
                log.Fatalf("negative license use at %s", f[timeField])
            }
            continue
        }
        out++
        if out < ml {
            continue
        }

        if out > ml {
            ml = out
            mlTimes = mlTimes[:0]
        }
        mlTimes = append(mlTimes, string(f[timeField]))
    }
    if err = s.Err(); err != nil {
        log.Fatal(err)
    }

    fmt.Println("max licenses:", ml)
    fmt.Println("at:")
    for _, t := range mlTimes {
        fmt.Println(" ", t)
    }
}
