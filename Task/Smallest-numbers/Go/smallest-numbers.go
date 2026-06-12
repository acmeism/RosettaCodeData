package main

import (
    "fmt"
    "math/big"
    "strconv"
    "strings"
)

func main() {
    var res []int64
    for n := 0; n <= 50; n++ {
        ns := strconv.Itoa(n)
        k := int64(1)
        for {
            bk := big.NewInt(k)
            s := bk.Exp(bk, bk, nil).String()
            if strings.Contains(s, ns) {
                res = append(res, k)
                break
            }
            k++
        }
    }
    fmt.Println("The smallest positive integers K where K ^ K contains N (0..50) are:")
    for i, n := range res {
        fmt.Printf("%2d ", n)
        if (i+1)%17 == 0 {
            fmt.Println()
        }
    }
}
