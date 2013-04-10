package main

import "fmt"

func main() {
    fmt.Println(mode([]interface{}{.2, .7, .1, .8, .2}))
    fmt.Println(mode([]interface{}{"two", 7, 1, 8, "two", 8}))
}

func mode(a []interface{}) []interface{} {
    m := make(map[interface{}]int)
    for _, v := range a {
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
