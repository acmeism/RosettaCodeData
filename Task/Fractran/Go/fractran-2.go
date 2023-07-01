package main

import (
    "fmt"
    "log"
    "math/big"
    "os"
    "os/exec"
)

func main() {
    c := exec.Command("ft", "1000000", "2", `17/91 78/85 19/51 23/38
        29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1`)
    c.Stderr = os.Stderr
    r, err := c.StdoutPipe()
    if err != nil {
        log.Fatal(err)
    }
    if err = c.Start(); err != nil {
        log.Fatal(err)
    }
    var n big.Int
    for primes := 0; primes < 20; {
        if _, err = fmt.Fscan(r, &n); err != nil {
            log.Fatal(err)
        }
        l := n.BitLen() - 1
        n.SetBit(&n, l, 0)
        if n.BitLen() == 0 && l > 1 {
            fmt.Printf("%d ", l)
            primes++
        }
    }
    fmt.Println()
}
