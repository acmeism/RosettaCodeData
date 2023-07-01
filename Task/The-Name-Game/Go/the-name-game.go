package main

import (
    "fmt"
    "strings"
)

func printVerse(name string) {
    x := strings.Title(strings.ToLower(name))
    y := x[1:]
    if strings.Contains("AEIOU", x[:1]) {
        y = strings.ToLower(x)
    }
    b := "b" + y
    f := "f" + y
    m := "m" + y
    switch x[0] {
    case 'B':
        b = y
    case 'F':
        f = y
    case 'M':
        m = y
    }
    fmt.Printf("%s, %s, bo-%s\n", x, x, b)
    fmt.Printf("Banana-fana fo-%s\n", f)
    fmt.Printf("Fee-fi-mo-%s\n", m)
    fmt.Printf("%s!\n\n", x)
}

func main() {
    names := [6]string{"gARY", "Earl", "Billy", "Felix", "Mary", "SHIRley"}
    for _, name := range names {
        printVerse(name)
    }
}
