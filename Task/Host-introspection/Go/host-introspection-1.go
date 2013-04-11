package main

import (
    "fmt"
    "io/ioutil"
    "strings"
    "unsafe"
)

func main() {
    // inspect an int variable to determine endianness
    x := 1
    if *(*byte)(unsafe.Pointer(&x)) == 1 {
        fmt.Println("little endian")
    } else {
        fmt.Println("big endian")
    }
    // inspect cpuinfo to determine word size (unix-like os only)
    c, err := ioutil.ReadFile("/proc/cpuinfo")
    if err != nil {
        fmt.Println(err)
        return
    }
    ls := strings.Split(string(c), "\n")
    for _, l := range ls {
        if strings.HasPrefix(l, "flags") {
            for _, f := range strings.Fields(l) {
                if f == "lm" { // "long mode"
                    fmt.Println("64 bit word size")
                    return
                }
            }
            fmt.Println("32 bit word size")
            return
        }
    }
    fmt.Println("cpuinfo flags not found")
}
