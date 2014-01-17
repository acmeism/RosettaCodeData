package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "net/http"
    "sort"
)

func main() {
    r, err := http.Get("http://www.puzzlers.org/pub/wordlists/unixdict.txt")
    if err != nil {
        fmt.Println(err)
        return
    }
    b, err := ioutil.ReadAll(r.Body)
    r.Body.Close()
    if err != nil {
        fmt.Println(err)
        return
    }
    var ma int
    var bs byteSlice
    m := make(map[string][][]byte)
    for _, word := range bytes.Fields(b) {
        bs = append(bs[:0], byteSlice(word)...)
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
            fmt.Printf("%s\n", a)
        }
    }
}

type byteSlice []byte

func (b byteSlice) Len() int           { return len(b) }
func (b byteSlice) Swap(i, j int)      { b[i], b[j] = b[j], b[i] }
func (b byteSlice) Less(i, j int) bool { return b[i] < b[j] }
