package main

import (
    "bufio"
    "fmt"
    "log"
    "math/rand"
    "os"
    "regexp"
    "strings"
    "time"
)

var dirs = [][]int{{1, 0}, {0, 1}, {1, 1}, {1, -1}, {-1, 0}, {0, -1}, {-1, -1}, {-1, 1}}

const (
    nRows    = 10
    nCols    = nRows
    gridSize = nRows * nCols
    minWords = 25
)

var (
    re1 = regexp.MustCompile(fmt.Sprintf("^[a-z]{3,%d}$", nRows))
    re2 = regexp.MustCompile("[^A-Z]")
)

type grid struct {
    numAttempts int
    cells       [nRows][nCols]byte
    solutions   []string
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func readWords(fileName string) []string {
    file, err := os.Open(fileName)
    check(err)
    defer file.Close()
    var words []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        word := strings.ToLower(strings.TrimSpace(scanner.Text()))
        if re1.MatchString(word) {
            words = append(words, word)
        }
    }
    check(scanner.Err())
    return words
}

func createWordSearch(words []string) *grid {
    var gr *grid
outer:
    for i := 1; i < 100; i++ {
        gr = new(grid)
        messageLen := gr.placeMessage("Rosetta Code")
        target := gridSize - messageLen
        cellsFilled := 0
        rand.Shuffle(len(words), func(i, j int) {
            words[i], words[j] = words[j], words[i]
        })
        for _, word := range words {
            cellsFilled += gr.tryPlaceWord(word)
            if cellsFilled == target {
                if len(gr.solutions) >= minWords {
                    gr.numAttempts = i
                    break outer
                } else { // grid is full but we didn't pack enough words, start over
                    break
                }
            }
        }
    }
    return gr
}

func (gr *grid) placeMessage(msg string) int {
    msg = strings.ToUpper(msg)
    msg = re2.ReplaceAllLiteralString(msg, "")
    messageLen := len(msg)
    if messageLen > 0 && messageLen < gridSize {
        gapSize := gridSize / messageLen
        for i := 0; i < messageLen; i++ {
            pos := i*gapSize + rand.Intn(gapSize)
            gr.cells[pos/nCols][pos%nCols] = msg[i]
        }
        return messageLen
    }
    return 0
}

func (gr *grid) tryPlaceWord(word string) int {
    randDir := rand.Intn(len(dirs))
    randPos := rand.Intn(gridSize)
    for dir := 0; dir < len(dirs); dir++ {
        dir = (dir + randDir) % len(dirs)
        for pos := 0; pos < gridSize; pos++ {
            pos = (pos + randPos) % gridSize
            lettersPlaced := gr.tryLocation(word, dir, pos)
            if lettersPlaced > 0 {
                return lettersPlaced
            }
        }
    }
    return 0
}

func (gr *grid) tryLocation(word string, dir, pos int) int {
    r := pos / nCols
    c := pos % nCols
    le := len(word)

    // check bounds
    if (dirs[dir][0] == 1 && (le+c) > nCols) ||
        (dirs[dir][0] == -1 && (le-1) > c) ||
        (dirs[dir][1] == 1 && (le+r) > nRows) ||
        (dirs[dir][1] == -1 && (le-1) > r) {
        return 0
    }
    overlaps := 0

    // check cells
    rr := r
    cc := c
    for i := 0; i < le; i++ {
        if gr.cells[rr][cc] != 0 && gr.cells[rr][cc] != word[i] {
            return 0
        }
        cc += dirs[dir][0]
        rr += dirs[dir][1]
    }

    // place
    rr = r
    cc = c
    for i := 0; i < le; i++ {
        if gr.cells[rr][cc] == word[i] {
            overlaps++
        } else {
            gr.cells[rr][cc] = word[i]
        }
        if i < le-1 {
            cc += dirs[dir][0]
            rr += dirs[dir][1]
        }
    }

    lettersPlaced := le - overlaps
    if lettersPlaced > 0 {
        sol := fmt.Sprintf("%-10s (%d,%d)(%d,%d)", word, c, r, cc, rr)
        gr.solutions = append(gr.solutions, sol)
    }
    return lettersPlaced
}

func printResult(gr *grid) {
    if gr.numAttempts == 0 {
        fmt.Println("No grid to display")
        return
    }
    size := len(gr.solutions)
    fmt.Println("Attempts:", gr.numAttempts)
    fmt.Println("Number of words:", size)
    fmt.Println("\n     0  1  2  3  4  5  6  7  8  9")
    for r := 0; r < nRows; r++ {
        fmt.Printf("\n%d   ", r)
        for c := 0; c < nCols; c++ {
            fmt.Printf(" %c ", gr.cells[r][c])
        }
    }
    fmt.Println("\n")
    for i := 0; i < size-1; i += 2 {
        fmt.Printf("%s   %s\n", gr.solutions[i], gr.solutions[i+1])
    }
    if size%2 == 1 {
        fmt.Println(gr.solutions[size-1])
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    unixDictPath := "/usr/share/dict/words"
    printResult(createWordSearch(readWords(unixDictPath)))
}
