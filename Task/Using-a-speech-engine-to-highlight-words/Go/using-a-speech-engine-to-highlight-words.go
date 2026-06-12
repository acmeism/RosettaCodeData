package main

import (
    "fmt"
    "log"
    "os/exec"
    "strings"
    "time"
)

func main() {
    s := "Actions speak louder than words."
    prev := ""
    prevLen := 0
    bs := ""
    for _, word := range strings.Fields(s) {
        cmd := exec.Command("espeak", word)
        if err := cmd.Run(); err != nil {
            log.Fatal(err)
        }
        if prevLen > 0 {
            bs = strings.Repeat("\b", prevLen)
        }
        fmt.Printf("%s%s%s ", bs, prev, strings.ToUpper(word))
        prev = word + " "
        prevLen = len(word) + 1
    }
    bs = strings.Repeat("\b", prevLen)
    time.Sleep(time.Second)
    fmt.Printf("%s%s\n", bs, prev)
}
