package main

import (
    "fmt"
    "strings"
)

func printBlock(data string, le int) {
    a := []byte(data)
    sumBytes := 0
    for _, b := range a {
        sumBytes += int(b - 48)
    }
    fmt.Printf("\nblocks %c, cells %d\n", a, le)
    if le-sumBytes <= 0 {
        fmt.Println("No solution")
        return
    }
    prep := make([]string, len(a))
    for i, b := range a {
        prep[i] = strings.Repeat("1", int(b-48))
    }
    for _, r := range genSequence(prep, le-sumBytes+1) {
        fmt.Println(r[1:])
    }
}

func genSequence(ones []string, numZeros int) []string {
    if len(ones) == 0 {
        return []string{strings.Repeat("0", numZeros)}
    }
    var result []string
    for x := 1; x < numZeros-len(ones)+2; x++ {
        skipOne := ones[1:]
        for _, tail := range genSequence(skipOne, numZeros-x) {
            result = append(result, strings.Repeat("0", x)+ones[0]+tail)
        }
    }
    return result
}

func main() {
    printBlock("21", 5)
    printBlock("", 5)
    printBlock("8", 10)
    printBlock("2323", 15)
    printBlock("23", 5)
}
