package main

import (
    f "fmt"
    s "strings"
)

var strLst = [...]string{
    "abc",
    "aabbcc",
    "abbc",
    "a",
    "",
    "the quick brown fox jumps over the lazy dog",
    "rosetta code",
    "hello, world!" }

func main() {
    for _, str := range strLst {
        if checkCorrelation(str) {
            f.Printf("The string \"%s\" is an ABC string\n", str)
        } else {
            f.Printf("The string \"%s\" is NOT an ABC string\n", str)
        }
    }
}

func checkCorrelation(str string) bool {
    aCount := s.Count(str, "a")
    bCount := s.Count(str, "b")
    cCount := s.Count(str, "c")

    return aCount == bCount && bCount == cCount
}
