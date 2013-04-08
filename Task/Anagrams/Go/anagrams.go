package main

import (
    "fmt"
    "io/ioutil"
    "sort"
    "strings"
)

func main() {
    b, err := ioutil.ReadFile("unixdict.txt")
    if err != nil {
        fmt.Println(err)
        return
    }
    var ma int
    m := make(map[string][]string)
    for _, word := range strings.Split(string(b), "\n") {
        bs := byteSlice(word)
        sort.Sort(bs)
        k := string(bs)
        a := append(m[k], word)
        if len(a) > ma {
            ma = len(a)
        }
        m[k] = a
    }
    for _, a := range m {
        if len(a) == ma {
            fmt.Println(a)
        }
    }
}

type byteSlice []byte

func (b byteSlice) Len() int { return len(b) }
func (b byteSlice) Swap(i, j int) { b[i], b[j] = b[j], b[i] }
func (b byteSlice) Less(i, j int) bool { return b[i] < b[j] }
