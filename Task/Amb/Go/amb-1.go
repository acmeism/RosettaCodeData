package main

import (
    "fmt"
    "sync"
)

func ambStrings(ss []string) chan []string {
    c := make(chan []string)
    go func() {
        for _, s := range ss {
            c <- []string{s}
        }
        close(c)
    }()
    return c
}

func ambChain(ss []string, cIn chan []string) chan []string {
    cOut := make(chan []string)
    go func() {
        var w sync.WaitGroup
        for chain := range cIn {
            w.Add(1)
            go func(chain []string) {
                for s1 := range ambStrings(ss) {
                    if s1[0][len(s1[0])-1] == chain[0][0] {
                        cOut <- append(s1, chain...)
                    }
                }
                w.Done()
            }(chain)
        }
        w.Wait()
        close(cOut)
    }()
    return cOut
}

func main() {
    s1 := []string{"the", "that", "a"}
    s2 := []string{"frog", "elephant", "thing"}
    s3 := []string{"walked", "treaded", "grows"}
    s4 := []string{"slowly", "quickly"}
    c := ambChain(s1, ambChain(s2, ambChain(s3, ambStrings(s4))))
    for s := range c {
        fmt.Println(s)
    }
}
