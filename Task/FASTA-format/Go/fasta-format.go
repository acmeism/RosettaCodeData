package main

import (
        "bufio"
        "fmt"
        "os"
)

func main() {
        f, err := os.Open("rc.fasta")
        if err != nil {
                fmt.Println(err)
                return
        }
        defer f.Close()
        s := bufio.NewScanner(f)
        headerFound := false
        for s.Scan() {
                line := s.Text()
                switch {
                case line == "":
                        continue
                case line[0] != '>':
                        if !headerFound {
                                fmt.Println("missing header")
                                return
                        }
                        fmt.Print(line)
                case headerFound:
                        fmt.Println()
                        fallthrough
                default:
                        fmt.Printf("%s: ", line[1:])
                        headerFound = true
                }
        }
        if headerFound {
                fmt.Println()
        }
        if err := s.Err(); err != nil {
                fmt.Println(err)
        }
}
