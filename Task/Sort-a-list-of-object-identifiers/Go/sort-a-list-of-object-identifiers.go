package main

import (
    "fmt"
    "log"
    "math/big"
    "sort"
    "strings"
)

var testCases = []string{
    "1.3.6.1.4.1.11.2.17.19.3.4.0.10",
    "1.3.6.1.4.1.11.2.17.5.2.0.79",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
    "1.3.6.1.4.1.11150.3.4.0.1",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.1",
    "1.3.6.1.4.1.11150.3.4.0",
}

// a parsed representation
type oid []big.Int

// "constructor" parses string representation
func newOid(s string) oid {
    ns := strings.Split(s, ".")
    os := make(oid, len(ns))
    for i, n := range ns {
        if _, ok := os[i].SetString(n, 10); !ok || os[i].Sign() < 0 {
            return nil
        }
    }
    return os
}

// "stringer" formats into string representation
func (o oid) String() string {
    s := make([]string, len(o))
    for i, n := range o {
        s[i] = n.String()
    }
    return strings.Join(s, ".")
}

func main() {
    // parse test cases
    os := make([]oid, len(testCases))
    for i, s := range testCases {
        os[i] = newOid(s)
        if os[i] == nil {
            log.Fatal("invalid OID")
        }
    }
    // sort
    sort.Slice(os, func(i, j int) bool {
        // "less" function must return true if os[i] < os[j]
        oi := os[i]
        for x, v := range os[j] {
            // lexicographic defintion: less if prefix or if element is <
            if x == len(oi) || oi[x].Cmp(&v) < 0 {
                return true
            }
            if oi[x].Cmp(&v) > 0 {
                break
            }
        }
        return false
    })
    // output sorted list
    for _, o := range os {
        fmt.Println(o)
    }
}
