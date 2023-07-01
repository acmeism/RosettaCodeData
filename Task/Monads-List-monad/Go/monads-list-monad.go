package main

import "fmt"

type mlist struct{ value []int }

func (m mlist) bind(f func(lst []int) mlist) mlist {
    return f(m.value)
}

func unit(lst []int) mlist {
    return mlist{lst}
}

func increment(lst []int) mlist {
    lst2 := make([]int, len(lst))
    for i, v := range lst {
        lst2[i] = v + 1
    }
    return unit(lst2)
}

func double(lst []int) mlist {
    lst2 := make([]int, len(lst))
    for i, v := range lst {
        lst2[i] = 2 * v
    }
    return unit(lst2)
}

func main() {
    ml1 := unit([]int{3, 4, 5})
    ml2 := ml1.bind(increment).bind(double)
    fmt.Printf("%v -> %v\n", ml1.value, ml2.value)
}
