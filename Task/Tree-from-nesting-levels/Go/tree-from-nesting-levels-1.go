package main

import "fmt"

type any = interface{}

func toTree(list []int) any {
    s := []any{[]any{}}
    for _, n := range list {
        for n != len(s) {
            if n > len(s) {
                inner := []any{}
                s[len(s)-1] = append(s[len(s)-1].([]any), inner)
                s = append(s, inner)
            } else {
                s = s[0 : len(s)-1]
            }
        }
        s[len(s)-1] = append(s[len(s)-1].([]any), n)
        for i := len(s) - 2; i >= 0; i-- {
            le := len(s[i].([]any))
            s[i].([]any)[le-1] = s[i+1]
        }
    }
    return s[0]
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
        nest := toTree(test)
        fmt.Printf("%17s => %v\n", fmt.Sprintf("%v", test), nest)
    }
}
