package main

import (
    "fmt"
    "strings"
)

func sentenceType(s string) string {
    if len(s) == 0 {
        return ""
    }
    var types []string
    for _, c := range s {
        if c == '?' {
            types = append(types, "Q")
        } else if c == '!' {
            types = append(types, "E")
        } else if c == '.' {
            types = append(types, "S")
        }
    }
    if strings.IndexByte("?!.", s[len(s)-1]) == -1 {
        types = append(types, "N")
    }
    return strings.Join(types, "|")
}

func main() {
    s := "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it"
    fmt.Println(sentenceType(s))
}
