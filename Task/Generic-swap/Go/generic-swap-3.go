package main

import (
    "fmt"
    "reflect"
)

func swap(a, b interface{}) error {
    ta := reflect.TypeOf(a)
    tb := reflect.TypeOf(b)
    if ta != tb {
        return fmt.Errorf("swap args are different types: %v and %v", ta, tb)
    }
    if ta.Kind() != reflect.Ptr {
        return fmt.Errorf("swap args must be pointers")
    }
    ea := reflect.ValueOf(a).Elem()
    eb := reflect.ValueOf(b).Elem()
    temp := reflect.New(ea.Type()).Elem()
    temp.Set(ea)
    ea.Set(eb)
    eb.Set(temp)
    return nil
}

func main() {
    a, b := 3, "cats"
    fmt.Println("a b:", a, b)
    err := swap(a, b)
    fmt.Println(err, "\n")

    c, d := 3, 4
    fmt.Println("c d:", c, d)
    err = swap(c, d)
    fmt.Println(err, "\n")

    e, f := 3, 4
    fmt.Println("e f:", e, f)
    swap(&e, &f)
    fmt.Println("e f:", e, f, "\n")

    type mult struct {
        int
        string
    }

    g, h := mult{3, "cats"}, mult{4, "dogs"}
    fmt.Println("g h:", g, h)
    swap(&g, &h)
    fmt.Println("g h:", g, h)
}
