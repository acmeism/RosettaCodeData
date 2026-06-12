package main

import (
    "fmt"
    "math/rand"
    "time"
)

var snl = map[int]int{
    4: 14, 9: 31, 17: 7, 20: 38, 28: 84, 40: 59, 51: 67, 54: 34,
    62: 19, 63: 81, 64: 60, 71: 91, 87: 24, 93: 73, 95: 75, 99: 78,
}

const sixThrowsAgain = true

func turn(player, square int) int {
    for {
        roll := 1 + rand.Intn(6)
        fmt.Printf("Player %d, on square %d, rolls a %d", player, square, roll)
        if square+roll > 100 {
            fmt.Println(" but cannot move.")
        } else {
            square += roll
            fmt.Printf(" and moves to square %d.\n", square)
            if square == 100 {
                return 100
            }
            next, ok := snl[square]
            if !ok {
                next = square
            }
            if square < next {
                fmt.Printf("Yay! Landed on a ladder. Climb up to %d.\n", next)
                if next == 100 {
                    return 100
                }
                square = next
            } else if square > next {
                fmt.Printf("Oops! Landed on a snake. Slither down to %d.\n", next)
                square = next
            }
        }
        if roll < 6 || !sixThrowsAgain {
            return square
        }
        fmt.Println("Rolled a 6 so roll again.")
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    // three players starting on square one
    players := [3]int{1, 1, 1}
    for {
        for i, s := range players {
            ns := turn(i+1, s)
            if ns == 100 {
                fmt.Println("Player", i+1, "wins!")
                return
            }
            players[i] = ns
            fmt.Println()
        }
    }
}
