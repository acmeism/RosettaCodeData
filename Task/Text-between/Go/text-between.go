package main

import (
    "fmt"
    "strings"
)

func textBetween(str, start, end string) string {
    if str == "" || start == "" || end == "" {
        return str
    }
    s := 0
    if start != "start" {
        s = strings.Index(str, start)
    }
    if s == -1 {
        return ""
    }
    si := 0
    if start != "start" {
        si = s + len(start)
    }
    e := len(str)
    if end != "end" {
        e = strings.Index(str[si:], end)
        if e == -1 {
            return str[si:]
        }
        e += si
    }
    return str[si:e]
}

func main() {
    texts := [9]string{
        "Hello Rosetta Code world",
        "Hello Rosetta Code world",
        "Hello Rosetta Code world",
        "</div><div style=\"chinese\">你好嗎</div>",
        "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">",
        "<table style=\"myTable\"><tr><td>hello world</td></tr></table>",
        "The quick brown fox jumps over the lazy other fox",
        "One fish two fish red fish blue fish",
        "FooBarBazFooBuxQuux",
    }
    starts:= [9]string{
        "Hello ", "start", "Hello ", "<div style=\"chinese\">",
        "<text>", "<table>", "quick ", "fish ", "Foo",
    }
    ends := [9]string{
        " world", " world", "end", "</div>", "<table>",
        "</table>", " fox", " red", "Foo",
    }
    for i, text := range texts {
        fmt.Printf("Text: \"%s\"\n", text)
        fmt.Printf("Start delimiter: \"%s\"\n", starts[i])
        fmt.Printf("End delimiter: \"%s\"\n", ends[i])
        b := textBetween(text, starts[i], ends[i])
        fmt.Printf("Output: \"%s\"\n\n", b)
    }
}
