package main

import "fmt"

func main() {
    // yes, there is more concise syntax, but this makes
    // the data types very clear.
    var b byte = 'a'
    var r rune = 'π'
    var s string = "aπ"

    fmt.Println(b, r, s)
    for _, c := range s { // this gives c the type rune
        fmt.Println(c)
    }
}
