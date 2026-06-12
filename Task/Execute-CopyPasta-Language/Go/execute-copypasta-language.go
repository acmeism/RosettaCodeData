// copypasta.go
package main

import (
    "fmt"
    "github.com/atotto/clipboard"
    "io/ioutil"
    "log"
    "os"
    "runtime"
    "strconv"
    "strings"
)

func check(err error) {
    if err != nil {
        clipboard.WriteAll("") // clear clipboard
        log.Fatal(err)
    }
}

func interpret(source string) {
    source2 := source
    if runtime.GOOS == "windows" {
        source2 = strings.ReplaceAll(source, "\r\n", "\n")
    }
    lines := strings.Split(source2, "\n")
    le := len(lines)
    for i := 0; i < le; i++ {
        lines[i] = strings.TrimSpace(lines[i]) // ignore leading & trailing whitespace
        switch lines[i] {
        case "Copy":
            if i == le-1 {
                log.Fatal("There are no lines after the Copy command.")
            }
            i++
            err := clipboard.WriteAll(lines[i])
            check(err)
        case "CopyFile":
            if i == le-1 {
                log.Fatal("There are no lines after the CopyFile command.")
            }
            i++
            if lines[i] == "TheF*ckingCode" {
                err := clipboard.WriteAll(source)
                check(err)
            } else {
                bytes, err := ioutil.ReadFile(lines[i])
                check(err)
                err = clipboard.WriteAll(string(bytes))
                check(err)
            }
        case "Duplicate":
            if i == le-1 {
                log.Fatal("There are no lines after the Duplicate command.")
            }
            i++
            times, err := strconv.Atoi(lines[i])
            check(err)
            if times < 0 {
                log.Fatal("Can't duplicate text a negative number of times.")
            }
            text, err := clipboard.ReadAll()
            check(err)
            err = clipboard.WriteAll(strings.Repeat(text, times+1))
            check(err)
        case "Pasta!":
            text, err := clipboard.ReadAll()
            check(err)
            fmt.Println(text)
            return
        default:
            if lines[i] == "" {
                continue // ignore blank lines
            }
            log.Fatal("Unknown command, " + lines[i])
        }
    }
}

func main() {
    if len(os.Args) != 2 {
        log.Fatal("There should be exactly one command line argument, the CopyPasta file path.")
    }
    bytes, err := ioutil.ReadFile(os.Args[1])
    check(err)
    interpret(string(bytes))
    err = clipboard.WriteAll("") // clear clipboard
    check(err)
}
