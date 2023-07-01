package main

import (
    "fmt"
    "log"
    "math/big"
    "strings"
)

type result struct {
    name  string
    size  int
    start int
    end   int
}

func (r result) String() string {
    return fmt.Sprintf("%-7s   %2d    %3d   %3d", r.name, r.size, r.start, r.end)
}

func validate(diagram string) []string {
    var lines []string
    for _, line := range strings.Split(diagram, "\n") {
        line = strings.Trim(line, " \t")
        if line != "" {
            lines = append(lines, line)
        }
    }
    if len(lines) == 0 {
        log.Fatal("diagram has no non-empty lines!")
    }
    width := len(lines[0])
    cols := (width - 1) / 3
    if cols != 8 && cols != 16 && cols != 32 && cols != 64 {
        log.Fatal("number of columns should be 8, 16, 32 or 64")
    }
    if len(lines)%2 == 0 {
        log.Fatal("number of non-empty lines should be odd")
    }
    if lines[0] != strings.Repeat("+--", cols)+"+" {
        log.Fatal("incorrect header line")
    }
    for i, line := range lines {
        if i == 0 {
            continue
        } else if i%2 == 0 {
            if line != lines[0] {
                log.Fatal("incorrect separator line")
            }
        } else if len(line) != width {
            log.Fatal("inconsistent line widths")
        } else if line[0] != '|' || line[width-1] != '|' {
            log.Fatal("non-separator lines must begin and end with '|'")
        }
    }
    return lines
}

func decode(lines []string) []result {
    fmt.Println("Name     Bits  Start  End")
    fmt.Println("=======  ====  =====  ===")
    start := 0
    width := len(lines[0])
    var results []result
    for i, line := range lines {
        if i%2 == 0 {
            continue
        }
        line := line[1 : width-1]
        for _, name := range strings.Split(line, "|") {
            size := (len(name) + 1) / 3
            name = strings.TrimSpace(name)
            res := result{name, size, start, start + size - 1}
            results = append(results, res)
            fmt.Println(res)
            start += size
        }
    }
    return results
}

func unpack(results []result, hex string) {
    fmt.Println("\nTest string in hex:")
    fmt.Println(hex)
    fmt.Println("\nTest string in binary:")
    bin := hex2bin(hex)
    fmt.Println(bin)
    fmt.Println("\nUnpacked:\n")
    fmt.Println("Name     Size  Bit pattern")
    fmt.Println("=======  ====  ================")
    for _, res := range results {
        fmt.Printf("%-7s   %2d   %s\n", res.name, res.size, bin[res.start:res.end+1])
    }
}

func hex2bin(hex string) string {
    z := new(big.Int)
    z.SetString(hex, 16)
    return fmt.Sprintf("%0*b", 4*len(hex), z)
}

func main() {
    const diagram = `
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                      ID                       |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    QDCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

        |                    ANCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    NSCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    ARCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    `
    lines := validate(diagram)
    fmt.Println("Diagram after trimming whitespace and removal of blank lines:\n")
    for _, line := range lines {
        fmt.Println(line)
    }
    fmt.Println("\nDecoded:\n")
    results := decode(lines)
    hex := "78477bbf5496e12e1bf169a4" // test string
    unpack(results, hex)
}
