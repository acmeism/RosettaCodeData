package main

import (
    "bufio"
    "fmt"
    "log"
    "math/rand"
    "os"
    "strconv"
    "time"
)

var scanner = bufio.NewScanner(os.Stdin)

var (
    total = 0
    quit  = false
)

func itob(i int) bool {
    if i == 0 {
        return false
    }
    return true
}

func getChoice() {
    for {
        fmt.Print("Your choice 1 to 3 : ")
        scanner.Scan()
        if scerr := scanner.Err(); scerr != nil {
            log.Fatalln(scerr, "when choosing number")
        }
        text := scanner.Text()
        if text == "q" || text == "Q" {
            quit = true
            return
        }
        input, err := strconv.Atoi(text)
        if err != nil {
            fmt.Println("Invalid number, try again")
            continue
        }
        newTotal := total + input
        switch {
        case input < 1 || input > 3:
            fmt.Println("Out of range, try again")
        case newTotal > 21:
            fmt.Println("Too big, try again")
        default:
            total = newTotal
            fmt.Println("Running total is now", total)
            return
        }
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    computer := itob(rand.Intn(2))
    fmt.Println("Enter q to quit at any time\n")
    if computer {
        fmt.Println("The computer will choose first")
    } else {
        fmt.Println("You will choose first")
    }
    fmt.Println("\nRunning total is now 0\n")
    var choice int
    for round := 1; ; round++ {
        fmt.Printf("ROUND %d:\n\n", round)
        for i := 0; i < 2; i++ {
            if computer {
                if total < 18 {
                    choice = 1 + rand.Intn(3)
                } else {
                    choice = 21 - total
                }
                total += choice
                fmt.Println("The computer chooses", choice)
                fmt.Println("Running total is now", total)
                if total == 21 {
                    fmt.Println("\nSo, commiserations, the computer has won!")
                    return
                }
            } else {
                getChoice()
                if quit {
                    fmt.Println("OK, quitting the game")
                    return
                }
                if total == 21 {
                    fmt.Println("\nSo, congratulations, you've won!")
                    return
                }
            }
            fmt.Println()
            computer = !computer
        }
    }
}
