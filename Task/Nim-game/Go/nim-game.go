package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
)

func showTokens(tokens int) {
    fmt.Println("Tokens remaining", tokens, "\n")
}

func main() {
    tokens := 12
    scanner := bufio.NewScanner(os.Stdin)
    for {
        showTokens(tokens)
        fmt.Print("  How many tokens 1, 2 or 3? ")
        scanner.Scan()
        if scerr := scanner.Err(); scerr != nil {
            fmt.Println("Error reading standard input:", scerr)
            return
        }
        t, err := strconv.Atoi(scanner.Text())
        if err != nil || t < 1 || t > 3 {
            fmt.Println("\nMust be a number between 1 and 3, try again.\n")
        } else {
            ct := 4 - t
            s := "s"
            if ct == 1 {
                s = ""
            }
            fmt.Print("  Computer takes ", ct, " token", s, "\n\n")
            tokens -= 4
        }
        if tokens == 0 {
            showTokens(0)
            fmt.Println("  Computer wins!")
            return
        }
    }
}
