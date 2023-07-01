package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "math"
    "os"
    "runtime"
)

func main() {
    _, src, _, _ := runtime.Caller(0)
    fmt.Println("Source file entropy:", entropy(src))
    fmt.Println("Binary file entropy:", entropy(os.Args[0]))
}

func entropy(file string) float64 {
    d, err := ioutil.ReadFile(file)
    if err != nil {
        log.Fatal(err)
    }
    var f [256]float64
    for _, b := range d {
        f[b]++
    }
    hm := 0.
    for _, c := range f {
        if c > 0 {
            hm += c * math.Log2(c)
        }
    }
    l := float64(len(d))
    return math.Log2(l) - hm/l
}
