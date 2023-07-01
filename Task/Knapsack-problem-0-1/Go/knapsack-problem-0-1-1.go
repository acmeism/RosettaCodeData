package main

import "fmt"

type item struct {
    string
    w, v int
}

var wants = []item{
    {"map", 9, 150},
    {"compass", 13, 35},
    {"water", 153, 200},
    {"sandwich", 50, 160},
    {"glucose", 15, 60},
    {"tin", 68, 45},
    {"banana", 27, 60},
    {"apple", 39, 40},
    {"cheese", 23, 30},
    {"beer", 52, 10},
    {"suntan cream", 11, 70},
    {"camera", 32, 30},
    {"T-shirt", 24, 15},
    {"trousers", 48, 10},
    {"umbrella", 73, 40},
    {"waterproof trousers", 42, 70},
    {"waterproof overclothes", 43, 75},
    {"note-case", 22, 80},
    {"sunglasses", 7, 20},
    {"towel", 18, 12},
    {"socks", 4, 50},
    {"book", 30, 10},
}

const maxWt = 400

func main() {
    items, w, v := m(len(wants)-1, maxWt)
    fmt.Println(items)
    fmt.Println("weight:", w)
    fmt.Println("value:", v)
}

func m(i, w int) ([]string, int, int) {
    if i < 0 || w == 0 {
        return nil, 0, 0
    } else if wants[i].w > w {
        return m(i-1, w)
    }
    i0, w0, v0 := m(i-1, w)
    i1, w1, v1 := m(i-1, w-wants[i].w)
    v1 += wants[i].v
    if v1 > v0 {
        return append(i1, wants[i].string), w1 + wants[i].w, v1
    }
    return i0, w0, v0
}
