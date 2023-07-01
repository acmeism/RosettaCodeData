package main

import (
    "fmt"
    "sync"
)

const (
    start    = "_###_##_#_#_#_#__#__"
    offLeft  = '_'
    offRight = '_'
    dead     = '_'
)

func main() {
    fmt.Println(start)
    a := make([]byte, len(start)+2)
    a[0] = offLeft
    copy(a[1:], start)
    a[len(a)-1] = offRight
    var read, write sync.WaitGroup
    read.Add(len(start) + 1)
    for i := 1; i <= len(start); i++ {
        go cell(a[i-1:i+2], &read, &write)
    }
    for i := 0; i < 10; i++ {
        write.Add(len(start) + 1)
        read.Done()
        read.Wait()
        read.Add(len(start) + 1)
        write.Done()
        write.Wait()
        fmt.Println(string(a[1 : len(a)-1]))
    }
}

func cell(kernel []byte, read, write *sync.WaitGroup) {
    var next byte
    for {
        l, v, r := kernel[0], kernel[1], kernel[2]
        read.Done()
        switch {
        case l != r:
            next = v
        case v == dead:
            next = l
        default:
            next = dead
        }
        read.Wait()
        kernel[1] = next
        write.Done()
        write.Wait()
    }
}
