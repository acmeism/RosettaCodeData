package main

import "fmt"

type any = interface{}

func toTree(list []int, index, depth int) (int, []any) {
    var soFar []any
    for index < len(list) {
        t := list[index]
        if t == depth {
            soFar = append(soFar, t)
        } else if t > depth {
            var deeper []any
            index, deeper = toTree(list, index, depth+1)
            soFar = append(soFar, deeper)
        } else {
            index = index - 1
            break
        }
        index = index + 1
    }
    if depth > 1 {
        return index, soFar
    }
    return -1, soFar
}

func main() {
    tests := [][]int{
        {},
        {1, 2, 4},
        {3, 1, 3, 1},
        {1, 2, 3, 1},
        {3, 2, 1, 3},
        {3, 3, 3, 1, 1, 3, 3, 3},
    }
    for _, test := range tests {
        _, nest := toTree(test, 0, 1)
        fmt.Printf("%17s => %v\n", fmt.Sprintf("%v", test), nest)
    }
}
