package main

import (
    "container/heap"
    "fmt"
    "io"
    "log"
    "os"
    "strings"
)

var s1 = "3 14 15"
var s2 = "2 17 18"
var s3 = ""
var s4 = "2 3 5 7"

func main() {
    fmt.Print("merge2: ")
    merge2(
        os.Stdout,
        strings.NewReader(s1),
        strings.NewReader(s2))
    fmt.Println()

    fmt.Print("mergeN: ")
    mergeN(
        os.Stdout,
        strings.NewReader(s1),
        strings.NewReader(s2),
        strings.NewReader(s3),
        strings.NewReader(s4))
    fmt.Println()
}

func r1(r io.Reader) (v int, ok bool) {
    switch _, err := fmt.Fscan(r, &v); {
    case err == nil:
        return v, true
    case err != io.EOF:
        log.Fatal(err)
    }
    return
}

func merge2(m io.Writer, s1, s2 io.Reader) {
    v1, d1 := r1(s1)
    v2, d2 := r1(s2)
    var v int
    for d1 || d2 {
        if !d2 || d1 && v1 < v2 {
            v = v1
            v1, d1 = r1(s1)
        } else {
            v = v2
            v2, d2 = r1(s2)
        }
        fmt.Fprint(m, v, " ")
    }
}

type sv struct {
    s io.Reader
    v int
}

type sh []sv

func (s sh) Len() int            { return len(s) }
func (s sh) Less(i, j int) bool  { return s[i].v < s[j].v }
func (s sh) Swap(i, j int)       { s[i], s[j] = s[j], s[i] }
func (p *sh) Push(x interface{}) { *p = append(*p, x.(sv)) }
func (p *sh) Pop() interface{} {
    s := *p
    last := len(s) - 1
    v := s[last]
    *p = s[:last]
    return v
}

func mergeN(m io.Writer, s ...io.Reader) {
    var h sh
    for _, s := range s {
        if v, d := r1(s); d {
            h = append(h, sv{s, v})
        }
    }
    heap.Init(&h)
    for len(h) > 0 {
        p := heap.Pop(&h).(sv)
        fmt.Fprint(m, p.v, " ")
        if v, d := r1(p.s); d {
            heap.Push(&h, sv{p.s, v})
        }
    }
}
