package main

import "fmt"

type any = interface{}

func showType(a any) {
    switch a.(type) {
    case rune:
        fmt.Printf("The type of '%c' is %T\n", a, a)
    default:
        fmt.Printf("The type of '%v' is %T\n", a, a)
    }
}

func main() {
    values := []any{5, 7.5, 2 + 3i, 'd', true, "Rosetta"}
    for _, value := range values {
        showType(value)
    }
}
