package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strings"
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func block2text(inputFile, outputFile string) {
    in, err := os.Open(inputFile)
    check(err)
    defer in.Close()

    out, err := os.Create(outputFile)
    check(err)
    defer out.Close()

    line := make([]byte, 64)
    empty := make([]byte, 64)
    for {
        n, err := in.Read(line)
        if err != nil {
            if n == 0 {
                break // EOF reached
            } else {
                log.Fatal(err)
            }
        }
        str := string(line)
        str = strings.TrimRight(str, " \000")
        out.WriteString(str + "\n")
        copy(line, empty)
    }
}

func text2block(inputFile, outputFile string) {
    in, err := os.Open(inputFile)
    check(err)
    defer in.Close()

    out, err := os.Create(outputFile)
    check(err)
    defer out.Close()

    scanner := bufio.NewScanner(in)
    count := 0
    for scanner.Scan() {
        str := scanner.Text()
        count++
        le := len(str)
        if le > 64 {
            str = str[0:64]
        } else if le < 64 {
            str = fmt.Sprintf("%-64s", str)
        }
        out.WriteString(str)
    }
    if rem := count % 16; rem > 0 {
        str := strings.Repeat(" ", (16-rem)*64)
        out.WriteString(str)
    }
}

func main() {
    block2text("block.dat", "block.txt")
    text2block("block.txt", "block2.dat")
}
