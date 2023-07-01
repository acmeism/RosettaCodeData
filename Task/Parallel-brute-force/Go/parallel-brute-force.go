package main

import (
    "crypto/sha256"
    "encoding/hex"
    "log"
    "sync"
)

var hh = []string{
    "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
    "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
    "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f",
}

func main() {
    log.SetFlags(0)
    hd := make([][sha256.Size]byte, len(hh))
    for i, h := range hh {
        hex.Decode(hd[i][:], []byte(h))
    }
    var wg sync.WaitGroup
    wg.Add(26)
    for c := byte('a'); c <= 'z'; c++ {
        go bf4(c, hd, &wg)
    }
    wg.Wait()
}

func bf4(c byte, hd [][sha256.Size]byte, wg *sync.WaitGroup) {
    p := []byte("aaaaa")
    p[0] = c
    p1 := p[1:]
p:
    for {
        ph := sha256.Sum256(p)
        for i, h := range hd {
            if h == ph {
                log.Println(string(p), hh[i])
            }
        }
        for i, v := range p1 {
            if v < 'z' {
                p1[i]++
                continue p
            }
            p1[i] = 'a'
        }
        wg.Done()
        return
    }
}
