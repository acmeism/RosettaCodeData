package main

import (
    "fmt"
    "strings"
    "unicode"
    "unicode/utf8"
)

func main() {
    show("alphaBETA")
    show("alpha BETA")
    show("Ǆǈǌ") // should render similar to DZLjnj
}

func show(s string) {
    fmt.Println("\nstring:         ", s, "len:", utf8.RuneCountInString(s))
    fmt.Println("All upper case: ", strings.ToUpper(s)) // DZLJNJ
    fmt.Println("All lower case: ", strings.ToLower(s)) // dzljnj
    fmt.Println("All title case: ", strings.ToTitle(s)) // DzLjNj
    // notice Title() only modifies first letters of words
    // non-first letters keep their case.
    fmt.Println("Title words:    ", strings.Title(s)) //   Dzljnj
    fmt.Println("Swapping case:  ", strings.Map(unicode.SimpleFold, s))
}
