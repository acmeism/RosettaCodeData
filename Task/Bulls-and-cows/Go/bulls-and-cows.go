package main

import (
    "bufio"
    "bytes"
    "fmt"
    "math/rand"
    "os"
    "strings"
    "time"
)

func main() {
    fmt.Println(`Cows and Bulls
Guess four digit number of unique digits in the range 1 to 9.
A correct digit but not in the correct place is a cow.
A correct digit in the correct place is a bull.`)
    // generate pattern
    pat := make([]byte, 4)
    rand.Seed(time.Now().Unix())
    r := rand.Perm(9)
    for i := range pat {
        pat[i] = '1' + byte(r[i])
    }

    // accept and score guesses
    valid := []byte("123456789")
guess:
    for in := bufio.NewReader(os.Stdin); ; {
        fmt.Print("Guess: ")
        guess, err := in.ReadString('\n')
        if err != nil {
            fmt.Println("\nSo, bye.")
            return
        }
        guess = strings.TrimSpace(guess)
        if len(guess) != 4 {
            // malformed:  not four characters
            fmt.Println("Please guess a four digit number.")
            continue
        }
        var cows, bulls int
        for ig, cg := range guess {
            if strings.IndexRune(guess[:ig], cg) >= 0 {
                // malformed:  repeated digit
                fmt.Printf("Repeated digit: %c\n", cg)
                continue guess
            }
            switch bytes.IndexByte(pat, byte(cg)) {
            case -1:
                if bytes.IndexByte(valid, byte(cg)) == -1 {
                    // malformed:  not a digit
                    fmt.Printf("Invalid digit: %c\n", cg)
                    continue guess
                }
            default: // I just think cows should go first
                cows++
            case ig:
                bulls++
            }
        }
        fmt.Printf("Cows: %d, bulls: %d\n", cows, bulls)
        if bulls == 4 {
            fmt.Println("You got it.")
            return
        }
    }
}
