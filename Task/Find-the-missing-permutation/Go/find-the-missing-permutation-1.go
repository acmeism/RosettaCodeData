package main

import (
    "fmt"
    "strings"
)

var given = strings.Split(`ABCD
CABD
ACDB
DACB
BCDA
ACBD
ADCB
CDAB
DABC
BCAD
CADB
CDBA
CBAD
ABDC
ADBC
BDCA
DCBA
BACD
BADC
BDAC
CBDA
DBCA
DCAB`, "\n")

func main() {
    b := make([]byte, len(given[0]))
    for i := range b {
        m := make(map[byte]int)
        for _, p := range given {
            m[p[i]]++
        }
        for char, count := range m {
            if count&1 == 1 {
                b[i] = char
                break
            }
        }
    }
    fmt.Println(string(b))
}
