package main

import (
    "bufio"
    "fmt"
    "log"
    "math/rand"
    "os"
    "strings"
    "time"
)

const (
    easy = 1
    hard = 4
)

var n [16]int

func initGrid() {
    for i := 0; i < 16; i++ {
        n[i] = i + 1
    }
}

func setDiff(level int) {
    moves := 3
    if level == hard {
        moves = 12
    }
    rc := make([]int, 0, 4)
    for i := 0; i < moves; i++ {
        rc = rc[:0]
        r := rand.Intn(2)
        s := rand.Intn(4)
        if r == 0 { // rotate random row
            for j := s * 4; j < (s+1)*4; j++ {
                rc = append(rc, j)
            }
        } else { // rotate random column
            for j := s; j < s+16; j += 4 {
                rc = append(rc, j)
            }
        }
        var rca [4]int
        copy(rca[:], rc)
        rotate(rca)
        if hasWon() { // do it again
            i = -1
        }
    }
    fmt.Println("Target is", moves, "moves.")
}

func drawGrid() {
    fmt.Println()
    fmt.Println("     D1   D2   D3   D4")
    fmt.Println("   ╔════╦════╦════╦════╗")
    fmt.Printf("R1 ║ %2d ║ %2d ║ %2d ║ %2d ║ L1\n", n[0], n[1], n[2], n[3])
    fmt.Println("   ╠════╬════╬════╬════╣")
    fmt.Printf("R2 ║ %2d ║ %2d ║ %2d ║ %2d ║ L2\n", n[4], n[5], n[6], n[7])
    fmt.Println("   ╠════╬════╬════╬════╣")
    fmt.Printf("R3 ║ %2d ║ %2d ║ %2d ║ %2d ║ L3\n", n[8], n[9], n[10], n[11])
    fmt.Println("   ╠════╬════╬════╬════╣")
    fmt.Printf("R4 ║ %2d ║ %2d ║ %2d ║ %2d ║ L4\n", n[12], n[13], n[14], n[15])
    fmt.Println("   ╚════╩════╩════╩════╝")
    fmt.Println("     U1   U2   U3   U4\n")
}

func rotate(ix [4]int) {
    last := n[ix[3]]
    for i := 3; i >= 1; i-- {
        n[ix[i]] = n[ix[i-1]]
    }
    n[ix[0]] = last
}

func hasWon() bool {
    for i := 0; i < 16; i++ {
        if n[i] != i+1 {
            return false
        }
    }
    return true
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    initGrid()
    rand.Seed(time.Now().UnixNano())
    level := easy
    scanner := bufio.NewScanner(os.Stdin)
    for {
        fmt.Print("Enter difficulty level easy or hard E/H : ")
        scanner.Scan()
        diff := strings.ToUpper(strings.TrimSpace(scanner.Text()))
        if diff != "E" && diff != "H" {
            fmt.Println("Invalid response, try again.")
        } else {
            if diff == "H" {
                level = hard
            }
            break
        }
    }
    check(scanner.Err())
    setDiff(level)
    var ix [4]int
    fmt.Println("When entering moves, you can also enter Q to quit or S to start again.")
    moves := 0
outer:
    for {
        drawGrid()
        if hasWon() {
            fmt.Println("Congratulations, you have won the game in", moves, "moves!!")
            return
        }
        for {
            fmt.Println("Moves so far =", moves, "\n")
            fmt.Print("Enter move : ")
            scanner.Scan()
            move := strings.ToUpper(strings.TrimSpace(scanner.Text()))
            check(scanner.Err())
            switch move {
            case "D1", "D2", "D3", "D4":
                c := int(move[1] - 49)
                ix[0] = 0 + c
                ix[1] = 4 + c
                ix[2] = 8 + c
                ix[3] = 12 + c
                rotate(ix)
                moves++
                continue outer
            case "L1", "L2", "L3", "L4":
                c := int(move[1] - 49)
                ix[0] = 3 + 4*c
                ix[1] = 2 + 4*c
                ix[2] = 1 + 4*c
                ix[3] = 0 + 4*c
                rotate(ix)
                moves++
                continue outer
            case "U1", "U2", "U3", "U4":
                c := int(move[1] - 49)
                ix[0] = 12 + c
                ix[1] = 8 + c
                ix[2] = 4 + c
                ix[3] = 0 + c
                rotate(ix)
                moves++
                continue outer
            case "R1", "R2", "R3", "R4":
                c := int(move[1] - 49)
                ix[0] = 0 + 4*c
                ix[1] = 1 + 4*c
                ix[2] = 2 + 4*c
                ix[3] = 3 + 4*c
                rotate(ix)
                moves++
                continue outer
            case "Q":
                return
            case "S":
                initGrid()
                setDiff(level)
                moves = 0
                continue outer
            default:
                fmt.Println("Invalid move, try again.")
            }
        }
    }
}
