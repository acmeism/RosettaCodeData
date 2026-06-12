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

var (
    b        = make([]rune, 100) // displayed board
    h        = make([]rune, 100) // hidden atoms
    scanner  = bufio.NewScanner(os.Stdin)
    wikiGame = true // set to false for a 'random' game
)

func initialize() {
    for i := 0; i < 100; i++ {
        b[i] = ' '
        h[i] = 'F'
    }
    if !wikiGame {
        hideAtoms()
    } else {
        h[32] = 'T'
        h[37] = 'T'
        h[64] = 'T'
        h[87] = 'T'
    }
    fmt.Println(`
    === BLACK BOX ===

    H    Hit (scores 1)
    R    Reflection (scores 1)
    1-9, Detour (scores 2)
    a-c  Detour for 10-12 (scores 2)
    G    Guess (maximum 4)
    Y    Correct guess
    N    Incorrect guess (scores 5)
    A    Unguessed atom

    Cells are numbered a0 to j9.
    Corner cells do nothing.
    Use edge cells to fire beam.
    Use middle cells to add/delete a guess.
    Game ends automatically after 4 guesses.
    Enter q to abort game at any time.
    `)
}

func drawGrid(score, guesses int) {
    fmt.Printf("      0   1   2   3   4   5   6   7   8   9 \n")
    fmt.Printf("\n")
    fmt.Printf("        ╔═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╗\n")
    fmt.Printf("a     %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c\n",
        b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9])
    fmt.Printf("    ╔═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╗\n")
    fmt.Printf("b   ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║\n",
        b[10], b[11], b[12], b[13], b[14], b[15], b[16], b[17], b[18], b[19])
    fmt.Printf("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣\n")
    fmt.Printf("c   ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║\n",
        b[20], b[21], b[22], b[23], b[24], b[25], b[26], b[27], b[28], b[29])
    fmt.Printf("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣\n")
    fmt.Printf("d   ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║\n",
        b[30], b[31], b[32], b[33], b[34], b[35], b[36], b[37], b[38], b[39])
    fmt.Printf("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣\n")
    fmt.Printf("e   ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║\n",
        b[40], b[41], b[42], b[43], b[44], b[45], b[46], b[47], b[48], b[49])
    fmt.Printf("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣\n")
    fmt.Printf("f   ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║\n",
        b[50], b[51], b[52], b[53], b[54], b[55], b[56], b[57], b[58], b[59])
    fmt.Printf("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣\n")
    fmt.Printf("g   ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║\n",
        b[60], b[61], b[62], b[63], b[64], b[65], b[66], b[67], b[68], b[69])
    fmt.Printf("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣\n")
    fmt.Printf("h   ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║\n",
        b[70], b[71], b[72], b[73], b[74], b[75], b[76], b[77], b[78], b[79])
    fmt.Printf("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣\n")
    fmt.Printf("i   ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║\n",
        b[80], b[81], b[82], b[83], b[84], b[85], b[86], b[87], b[88], b[89])
    fmt.Printf("    ╚═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╝\n")
    fmt.Printf("j     %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c ║ %c\n",
        b[90], b[91], b[92], b[93], b[94], b[95], b[96], b[97], b[98], b[99])
    fmt.Printf("        ╚═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╝\n")
    status := "In play"
    if guesses == 4 {
        status = "Game over!"
    }
    fmt.Println("\n        Score =", score, "\tGuesses =", guesses, "\t Status =", status, "\n")
}

func hideAtoms() {
    placed := 0
    for placed < 4 {
        a := 11 + rand.Intn(78) // 11 to 88 inclusive
        m := a % 10
        if m == 0 || m == 9 || h[a] == 'T' {
            continue
        }
        h[a] = 'T'
        placed++
    }
}

func nextCell() int {
    var ix int
    for {
        fmt.Print("    Choose cell : ")
        scanner.Scan()
        sq := strings.ToLower(scanner.Text())
        if len(sq) == 1 && sq[0] == 'q' {
            log.Fatal("program aborted")
        }
        if len(sq) != 2 || sq[0] < 'a' || sq[0] > 'j' || sq[1] < '0' || sq[1] > '9' {
            continue
        }
        ix = int((sq[0]-'a')*10 + sq[1] - 48)
        if atCorner(ix) {
            continue
        }
        break
    }
    check(scanner.Err())
    fmt.Println()
    return ix
}

func atCorner(ix int) bool { return ix == 0 || ix == 9 || ix == 90 || ix == 99 }

func inRange(ix int) bool { return ix >= 1 && ix <= 98 && ix != 9 && ix != 90 }

func atTop(ix int) bool { return ix >= 1 && ix <= 8 }

func atBottom(ix int) bool { return ix >= 91 && ix <= 98 }

func atLeft(ix int) bool { return inRange(ix) && ix%10 == 0 }

func atRight(ix int) bool { return inRange(ix) && ix%10 == 9 }

func inMiddle(ix int) bool {
    return inRange(ix) && !atTop(ix) && !atBottom(ix) && !atLeft(ix) && !atRight(ix)
}

func play() {
    score, guesses := 0, 0
    num := '0'
outer:
    for {
        drawGrid(score, guesses)
        ix := nextCell()
        if !inMiddle(ix) && b[ix] != ' ' { // already processed
            continue
        }
        var inc, def int
        switch {
        case atTop(ix):
            inc, def = 10, 1
        case atBottom(ix):
            inc, def = -10, 1
        case atLeft(ix):
            inc, def = 1, 10
        case atRight(ix):
            inc, def = -1, 10
        default:
            if b[ix] != 'G' {
                b[ix] = 'G'
                guesses++
                if guesses == 4 {
                    break outer
                }
            } else {
                b[ix] = ' '
                guesses--
            }
            continue
        }
        var x int
        first := true
        for x = ix + inc; inMiddle(x); x += inc {
            if h[x] == 'T' { // hit
                b[ix] = 'H'
                score++
                first = false
                continue outer
            }
            if first && (inMiddle(x+def) && h[x+def] == 'T') ||
                (inMiddle(x-def) && h[x-def] == 'T') { // reflection
                b[ix] = 'R'
                score++
                first = false
                continue outer
            }
            first = false
            y := x + inc - def
            if inMiddle(y) && h[y] == 'T' { // deflection
                switch inc {
                case 1, -1:
                    inc, def = 10, 1
                case 10, -10:
                    inc, def = 1, 10
                }
            }
            y = x + inc + def
            if inMiddle(y) && h[y] == 'T' { // deflection or double deflection
                switch inc {
                case 1, -1:
                    inc, def = -10, 1
                case 10, -10:
                    inc, def = -1, 10
                }
            }
        }
        if num != '9' {
            num++
        } else {
            num = 'a'
        }
        if b[ix] == ' ' {
            score++
        }
        b[ix] = num
        if inRange(x) {
            if ix == x {
                b[ix] = 'R'
            } else {
                if b[x] == ' ' {
                    score++
                }
                b[x] = num
            }
        }
    }
    drawGrid(score, guesses)
    finalScore(score, guesses)
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func finalScore(score, guesses int) {
    for i := 11; i <= 88; i++ {
        m := i % 10
        if m == 0 || m == 9 {
            continue
        }
        if b[i] == 'G' && h[i] == 'T' {
            b[i] = 'Y'
        } else if b[i] == 'G' && h[i] == 'F' {
            b[i] = 'N'
            score += 5
        } else if b[i] == ' ' && h[i] == 'T' {
            b[i] = 'A'
        }
    }
    drawGrid(score, guesses)
}

func main() {
    rand.Seed(time.Now().UnixNano())
    for {
        initialize()
        play()
    inner:
        for {
            fmt.Print("    Play again y/n : ")
            scanner.Scan()
            yn := strings.ToLower(scanner.Text())
            switch yn {
            case "n":
                return
            case "y":
                break inner
            }
        }
        check(scanner.Err())
    }
}
