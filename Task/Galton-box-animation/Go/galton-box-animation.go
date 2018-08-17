package main

import (
    "fmt"
    "math/rand"
    "time"
)

const boxW = 41      // Galton box width
const boxH = 37      // Galton box height.
const pinsBaseW = 19 // Pins triangle base.
const nMaxBalls = 55 // Number of balls.

const centerH = pinsBaseW + (boxW-pinsBaseW*2+1)/2 - 1

const (
    empty  = ' '
    ball   = 'o'
    wall   = '|'
    corner = '+'
    floor  = '-'
    pin    = '.'
)

type Ball struct{ x, y int }

func newBall(x, y int) *Ball {
    if box[y][x] != empty {
        panic("Tried to create a new ball in a non-empty cell. Program terminated.")
    }
    b := Ball{x, y}
    box[y][x] = ball
    return &b
}

func (b *Ball) doStep() {
    if b.y <= 0 {
        return // Reached the bottom of the box.
    }
    cell := box[b.y-1][b.x]
    switch cell {
    case empty:
        box[b.y][b.x] = empty
        b.y--
        box[b.y][b.x] = ball
    case pin:
        box[b.y][b.x] = empty
        b.y--
        if box[b.y][b.x-1] == empty && box[b.y][b.x+1] == empty {
            b.x += rand.Intn(2)*2 - 1
            box[b.y][b.x] = ball
            return
        } else if box[b.y][b.x-1] == empty {
            b.x++
        } else {
            b.x--
        }
        box[b.y][b.x] = ball
    default:
        // It's frozen - it always piles on other balls.
    }
}

type Cell = byte

/* Galton box. Will be printed upside down. */
var box [boxH][boxW]Cell

func initializeBox() {
    // Set ceiling and floor
    box[0][0] = corner
    box[0][boxW-1] = corner
    for i := 1; i < boxW-1; i++ {
        box[0][i] = floor
    }
    for i := 0; i < boxW; i++ {
        box[boxH-1][i] = box[0][i]
    }

    // Set walls
    for r := 1; r < boxH-1; r++ {
        box[r][0] = wall
        box[r][boxW-1] = wall
    }

    // Set rest to empty initially
    for i := 1; i < boxH-1; i++ {
        for j := 1; j < boxW-1; j++ {
            box[i][j] = empty
        }
    }

    // Set pins
    for nPins := 1; nPins <= pinsBaseW; nPins++ {
        for p := 0; p < nPins; p++ {
            box[boxH-2-nPins][centerH+1-nPins+p*2] = pin
        }
    }
}

func drawBox() {
    for r := boxH - 1; r >= 0; r-- {
        for c := 0; c < boxW; c++ {
            fmt.Printf("%c", box[r][c])
        }
        fmt.Println()
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    initializeBox()
    var balls []*Ball
    for i := 0; i < nMaxBalls+boxH; i++ {
        fmt.Println("\nStep", i, ":")
        if i < nMaxBalls {
            balls = append(balls, newBall(centerH, boxH-2)) // add ball
        }
        drawBox()

        // Next step for the simulation.
        // Frozen balls are kept in balls slice for simplicity
        for _, b := range balls {
            b.doStep()
        }
    }
}
