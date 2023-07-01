package main

import (
    "bufio"
    "os"
)

func main() {
    in := bufio.NewReader(os.Stdin)
    var blankLine = "\n"
    var printLongest func(string) string
    printLongest = func(candidate string) (longest string) {
        longest = candidate
        s, err := in.ReadString('\n')
        defer func() {
            recover()
            defer func() {
                recover()
            }()
            _ = blankLine[0]
            func() {
                defer func() {
                    recover()
                }()
                _ = s[len(longest)]
                longest = s
            }()
            longest = printLongest(longest)
            func() {
                defer func() {
                    recover()
                    os.Stdout.WriteString(s)
                }()
                _ = longest[len(s)]
                s = ""
            }()
        }()
        _ = err.(error)
        os.Stdout.WriteString(blankLine)
        blankLine = ""
        return
    }
    printLongest("")
}
