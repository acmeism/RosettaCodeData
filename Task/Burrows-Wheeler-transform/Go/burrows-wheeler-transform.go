package main

import (
    "fmt"
    "sort"
    "strings"
)

const stx = "\002"
const etx = "\003"

func bwt(s string) (string, error) {
    if strings.Index(s, stx) >= 0 || strings.Index(s, etx) >= 0 {
        return "", fmt.Errorf("String can't contain STX or ETX")
    }
    s = stx + s + etx
    le := len(s)
    table := make([]string, le)
    table[0] = s
    for i := 1; i < le; i++ {
        table[i] = s[i:] + s[:i]
    }
    sort.Strings(table)
    lastBytes := make([]byte, le)
    for i := 0; i < le; i++ {
        lastBytes[i] = table[i][le-1]
    }
    return string(lastBytes), nil
}

func ibwt(r string) string {
    le := len(r)
    table := make([]string, le)
    for range table {
        for i := 0; i < le; i++ {
            table[i] = r[i:i+1] + table[i]
        }
        sort.Strings(table)
    }
    for _, row := range table {
        if strings.HasSuffix(row, etx) {
            return row[1 : le-1]
        }
    }
    return ""
}

func makePrintable(s string) string {
    // substitute ^ for STX and | for ETX to print results
    t := strings.Replace(s, stx, "^", 1)
    return strings.Replace(t, etx, "|", 1)
}

func main() {
    tests := []string{
        "banana",
        "appellee",
        "dogwood",
        "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
        "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
        "\002ABC\003",
    }
    for _, test := range tests {
        fmt.Println(makePrintable(test))
        fmt.Print(" --> ")
        t, err := bwt(test)
        if err != nil {
            fmt.Println("ERROR:", err)
        } else {
            fmt.Println(makePrintable(t))
        }
        r := ibwt(t)
        fmt.Println(" -->", r, "\n")
    }
}
