package main

import "fmt"

type S struct {
    start, stop, incr int
    comment          string
}

var examples = []S{
    {-2, 2, 1, "Normal"},
    {-2, 2, 0, "Zero increment"},
    {-2, 2, -1, "Increments away from stop value"},
    {-2, 2, 10, "First increment is beyond stop value"},
    {2, -2, 1, "Start more than stop: positive increment"},
    {2, 2, 1, "Start equal stop: positive increment"},
    {2, 2, -1, "Start equal stop: negative increment"},
    {2, 2, 0, "Start equal stop: zero increment"},
    {0, 0, 0, "Start equal stop equal zero: zero increment"},
}

func sequence(s S, limit int) []int {
    var seq []int
    for i, c := s.start, 0; i <= s.stop && c < limit; i, c = i+s.incr, c+1 {
        seq = append(seq, i)
    }
    return seq
}

func main() {
    const limit = 10
    for _, ex := range examples {
        fmt.Println(ex.comment)
        fmt.Printf("Range(%d, %d, %d) -> ", ex.start, ex.stop, ex.incr)
        fmt.Println(sequence(ex, limit))
        fmt.Println()
    }
}
