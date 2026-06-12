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

const (
    esc  = "\033"
    test = true // set to 'false' to erase each player's coins
)

var scanner = bufio.NewScanner(os.Stdin)

func indexOf(s []int, el int) int {
    for i, v := range s {
        if v == el {
            return i
        }
    }
    return -1
}

func getNumber(prompt string, min, max int, showMinMax bool) (int, error) {
    for {
        fmt.Print(prompt)
        if showMinMax {
            fmt.Printf(" from %d to %d : ", min, max)
        } else {
            fmt.Printf(" : ")
        }
        scanner.Scan()
        if scerr := scanner.Err(); scerr != nil {
            return 0, scerr
        }
        input, err := strconv.Atoi(scanner.Text())
        if err == nil && input >= min && input <= max {
            fmt.Println()
            return input, nil
        }
    }
}

func check(err error, text string) {
    if err != nil {
        log.Fatalln(err, text)
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    players, err := getNumber("Number of players", 2, 9, true)
    check(err, "when getting players")
    coins, err2 := getNumber("Number of coins per player", 3, 6, true)
    check(err2, "when getting coins")
    remaining := make([]int, players)
    for i := range remaining {
        remaining[i] = i + 1
    }
    first := 1 + rand.Intn(players)
    fmt.Println("The number of coins in your hand will be randomly determined for")
    fmt.Println("each round and displayed to you. However, when you press ENTER")
    fmt.Println("it will be erased so that the other players, who should look")
    fmt.Println("away until it's their turn, won't see it. When asked to guess")
    fmt.Println("the total, the computer won't allow a 'bum guess'.")
    for round := 1; ; round++ {
        fmt.Printf("\nROUND %d:\n\n", round)
        n := first
        hands := make([]int, players+1)
        guesses := make([]int, players+1)
        for i := range guesses {
            guesses[i] = -1
        }
        for {
            fmt.Printf("  PLAYER %d:\n", n)
            fmt.Println("    Please come to the computer and press ENTER")
            hands[n] = rand.Intn(coins + 1)
            fmt.Print("      <There are ", hands[n], " coin(s) in your hand>")
            scanner.Scan()
            check(scanner.Err(), "when pressing ENTER")
            if !test {
                fmt.Print(esc, "[1A") // move cursor up one line
                fmt.Print(esc, "[2K") // erase line
                fmt.Println("\r")     // move cursor to beginning of line
            } else {
                fmt.Println()
            }
            for {
                min := hands[n]
                max := (len(remaining)-1)*coins + hands[n]
                guess, err3 := getNumber("    Guess the total", min, max, false)
                check(err3, "when guessing the total")
                if indexOf(guesses, guess) == -1 {
                    guesses[n] = guess
                    break
                }
                fmt.Println("    Already guessed by another player, try again")
            }
            index := indexOf(remaining, n)
            if index < len(remaining)-1 {
                n = remaining[index+1]
            } else {
                n = remaining[0]
            }
            if n == first {
                break
            }
        }
        total := 0
        for _, hand := range hands {
            total += hand
        }
        fmt.Println("  Total coins held =", total)
        eliminated := false
        for _, v := range remaining {
            if guesses[v] == total {
                fmt.Println("  PLAYER", v, "guessed correctly and is eliminated")
                r := indexOf(remaining, v)
                remaining = append(remaining[:r], remaining[r+1:]...)
                eliminated = true
                break
            }
        }
        if !eliminated {
            fmt.Println("  No players guessed correctly in this round")
        } else if len(remaining) == 1 {
            fmt.Println("\nPLAYER", remaining[0], "buys the drinks!")
            return
        }
        index2 := indexOf(remaining, n)
        if index2 < len(remaining)-1 {
            first = remaining[index2+1]
        } else {
            first = remaining[0]
        }
    }
}
