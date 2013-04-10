package main

import "fmt"

// interface type
type intCollection interface {
    iterator() func() (int, bool)
}

// concrete type implements interface
type intSlice []int

// method on concrete type satisfies interface method
func (s intSlice) iterator() func() (int, bool) {
    i := 0
    return func() (int, bool) {
        if i >= len(s) {
            return 0, false
        }
        v := s[i]
        i++
        return v, true
    }
}

func main() {
    fmt.Println(mode(intSlice{2, 7, 1, 8, 2}))
    fmt.Println(mode(intSlice{2, 7, 1, 8, 2, 8}))
}

// mode is now a generic function, in a sense.
// It knows what to do with an intCollection,
// but does not know the underlying concrete type.
func mode(a intCollection) []int {
    m := make(map[int]int)
    i := a.iterator()
    for {
        v, ok := i()
        if !ok {
            break
        }
        m[v]++
    }
    var mode []int
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
