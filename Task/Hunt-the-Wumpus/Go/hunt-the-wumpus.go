package main

import (
    "bufio"
    "fmt"
    "log"
    "math/rand"
    "os"
    "strconv"
    "strings"
    "time"
)

var cave = map[int][3]int{
    1: {2, 3, 4}, 2: {1, 5, 6}, 3: {1, 7, 8}, 4: {1, 9, 10}, 5: {2, 9, 11},
    6: {2, 7, 12}, 7: {3, 6, 13}, 8: {3, 10, 14}, 9: {4, 5, 15}, 10: {4, 8, 16},
    11: {5, 12, 17}, 12: {6, 11, 18}, 13: {7, 14, 18}, 14: {8, 13, 19},
    15: {9, 16, 17}, 16: {10, 15, 19}, 17: {11, 20, 15}, 18: {12, 13, 20},
    19: {14, 16, 20}, 20: {17, 18, 19},
}

var player, wumpus, bat1, bat2, pit1, pit2 int

var arrows = 5

func isEmpty(r int) bool {
    if r != player && r != wumpus && r != bat1 && r != bat2 && r != pit1 && r != pit2 {
        return true
    }
    return false
}

func sense(adj [3]int) {
    bat := false
    pit := false
    for _, ar := range adj {
        if ar == wumpus {
            fmt.Println("You smell something terrible nearby.")
        }
        switch ar {
        case bat1, bat2:
            if !bat {
                fmt.Println("You hear a rustling.")
                bat = true
            }
        case pit1, pit2:
            if !pit {
                fmt.Println("You feel a cold wind blowing from a nearby cavern.")
                pit = true
            }
        }
    }
    fmt.Println()
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func plural(n int) string {
    if n != 1 {
        return "s"
    }
    return ""
}

func main() {
    rand.Seed(time.Now().UnixNano())
    player = 1
    wumpus = rand.Intn(19) + 2 // 2 to 20
    bat1 = rand.Intn(19) + 2
    for {
        bat2 = rand.Intn(19) + 2
        if bat2 != bat1 {
            break
        }
    }
    for {
        pit1 = rand.Intn(19) + 2
        if pit1 != bat1 && pit1 != bat2 {
            break
        }
    }
    for {
        pit2 = rand.Intn(19) + 2
        if pit2 != bat1 && pit2 != bat2 && pit2 != pit1 {
            break
        }
    }
    scanner := bufio.NewScanner(os.Stdin)
    for {
        fmt.Printf("\nYou are in room %d with %d arrow%s left\n", player, arrows, plural(arrows))
        adj := cave[player]
        fmt.Printf("The adjacent rooms are %v\n", adj)
        sense(adj)
        var room int
        for {
            fmt.Print("Choose an adjacent room : ")
            scanner.Scan()
            room, _ = strconv.Atoi(scanner.Text())
            if room != adj[0] && room != adj[1] && room != adj[2] {
                fmt.Println("Invalid response, try again")
            } else {
                break
            }
        }
        check(scanner.Err())
        var action byte
        for {
            fmt.Print("Walk or shoot w/s : ")
            scanner.Scan()
            reply := strings.ToLower(scanner.Text())
            if len(reply) != 1 || (len(reply) == 1 && reply[0] != 'w' && reply[0] != 's') {
                fmt.Println("Invalid response, try again")
            } else {
                action = reply[0]
                break
            }
        }
        check(scanner.Err())
        if action == 'w' {
            player = room
            switch player {
            case wumpus:
                fmt.Println("You have been eaten by the Wumpus and lost the game!")
                return
            case pit1, pit2:
                fmt.Println("You have fallen down a bottomless pit and lost the game!")
                return
            case bat1, bat2:
                for {
                    room = rand.Intn(19) + 2
                    if isEmpty(room) {
                        fmt.Println("A bat has transported you to a random empty room")
                        player = room
                        break
                    }
                }
            }
        } else {
            if room == wumpus {
                fmt.Println("You have killed the Wumpus and won the game!!")
                return
            } else {
                chance := rand.Intn(4) // 0 to 3
                if chance > 0 {        // 75% probability
                    wumpus = cave[wumpus][rand.Intn(3)]
                    if player == wumpus {
                        fmt.Println("You have been eaten by the Wumpus and lost the game!")
                        return
                    }
                }
            }
            arrows--
            if arrows == 0 {
                fmt.Println("You have run out of arrows and lost the game!")
                return
            }
        }
    }
}
