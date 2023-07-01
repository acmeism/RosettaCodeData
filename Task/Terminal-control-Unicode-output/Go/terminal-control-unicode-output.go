package main

import (
    "fmt"
    "os"
    "strings"
)

func main() {
    lang := strings.ToUpper(os.Getenv("LANG"))
    if strings.Contains(lang, "UTF") {
        fmt.Printf("This terminal supports unicode and U+25b3 is : %c\n", '\u25b3')
    } else {
        fmt.Println("This terminal does not support unicode")
    }
}
