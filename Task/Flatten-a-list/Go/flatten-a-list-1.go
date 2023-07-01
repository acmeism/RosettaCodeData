package main

import "fmt"

func list(s ...interface{}) []interface{} {
    return s
}

func main() {
    s := list(list(1),
        2,
        list(list(3, 4), 5),
        list(list(list())),
        list(list(list(6))),
        7,
        8,
        list(),
    )
    fmt.Println(s)
    fmt.Println(flatten(s))
}

func flatten(s []interface{}) (r []int) {
    for _, e := range s {
        switch i := e.(type) {
        case int:
            r = append(r, i)
        case []interface{}:
            r = append(r, flatten(i)...)
        }
    }
    return
}
