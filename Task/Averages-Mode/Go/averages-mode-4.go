package main

import "fmt"

type collection interface {
    iterator() func() (interface{}, bool)
}

type intSlice []int

func (s intSlice) iterator() func() (interface{}, bool) {
    i := 0
    return func() (interface{}, bool) {
        if i >= len(s) {
            return 0, false
        }
        v := s[i]
        i++
        return v, true
    }
}

type runeList string

func (s runeList) iterator() func() (interface{}, bool) {
    c := make(chan rune)
    go func() {
        for _, r := range s {
            c <- r
        }
        close(c)
    }()
    return func() (interface{}, bool) {
        r, ok := <-c
        return string(r), ok
    }
}

func main() {
    fmt.Println(mode(intSlice{2, 7, 1, 8, 2}))
    fmt.Println(mode(runeList("Enzyklopädie")))
}

func mode(a collection) []interface{} {
    m := make(map[interface{}]int)
    i := a.iterator()
    for {
        v, ok := i()
        if !ok {
            break
        }
        m[v]++
    }
    var mode []interface{}
    var n int
    for k, v := range m {
        switch {
        case v < n:
        case v > n:
            n = v
            mode = append(mode[:0], k)
        default:
            mode = append(mode, k)
        }
    }
    return mode
}
