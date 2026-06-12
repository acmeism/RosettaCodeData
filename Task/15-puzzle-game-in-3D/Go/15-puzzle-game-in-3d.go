package main

import (
    "fmt"
    "github.com/gen2brain/raylib-go/raylib"
    "math"
    "math/rand"
    "strconv"
    "time"
)

var palette = []rl.Color{
    rl.Blue,
    rl.Green,
    rl.Red,
    rl.SkyBlue,
    rl.Magenta,
    rl.Gray,
    rl.Lime,
    rl.Purple,
    rl.Violet,
    rl.Pink,
    rl.Gold,
    rl.Orange,
    rl.Maroon,
    rl.Beige,
    rl.Brown,
    rl.RayWhite,
}

var (
    screenWidth  = int32(960)
    screenHeight = int32(840)
    radius       = screenHeight / 14
    fontSize     = 2 * radius / 5
    angle        = math.Pi / 6
    incr         = 2 * angle
    blank        = 15
    moves        = 0
    gameOver     = false
)

var (
    centers [16]rl.Vector2
    cubes   [16]int
)

func init() {
    for i := 0; i < 16; i++ {
        cubes[i] = i
    }
}

func drawCube(n, pos int) {
    r := float32(radius)
    rl.DrawPoly(centers[pos], 6, r, 0, palette[n])
    cx, cy := centers[pos].X, centers[pos].Y
    for i := 1; i <= 5; i += 2 {
        fi := float64(i)
        vx := int32(r*float32(math.Cos(angle+fi*incr)) + cx)
        vy := int32(r*float32(math.Sin(angle+fi*incr)) + cy)
        rl.DrawLine(int32(cx), int32(cy), vx, vy, rl.Black)
    }
    ns := ""
    if n < 15 || gameOver {
        ns = strconv.Itoa(n + 1)
    }
    hr, er, tqr := r/2, r/8, 0.75*r
    rl.DrawText(ns, int32(cx+hr-er), int32(cy), fontSize, rl.RayWhite)
    rl.DrawText(ns, int32(cx-hr-er), int32(cy), fontSize, rl.RayWhite)
    rl.DrawText(ns, int32(cx-er), int32(cy-tqr), fontSize, rl.RayWhite)
}

func updateGame() {
    if gameOver {
        return
    } else if rl.IsKeyPressed(rl.KeyLeft) {
        if blank%4 != 0 {
            cubes[blank], cubes[blank-1] = cubes[blank-1], cubes[blank]
            blank--
            moves++
        }
    } else if rl.IsKeyPressed(rl.KeyRight) {
        if (blank+1)%4 != 0 {
            cubes[blank], cubes[blank+1] = cubes[blank+1], cubes[blank]
            blank++
            moves++
        }
    } else if rl.IsKeyPressed(rl.KeyUp) {
        if blank > 3 {
            cubes[blank], cubes[blank-4] = cubes[blank-4], cubes[blank]
            blank -= 4
            moves++
        }
    } else if rl.IsKeyPressed(rl.KeyDown) {
        if blank < 12 {
            cubes[blank], cubes[blank+4] = cubes[blank+4], cubes[blank]
            blank += 4
            moves++
        }
    }
}

func completed() bool {
    for i := 0; i < 16; i++ {
        if cubes[i] != i {
            return false
        }
    }
    palette[15] = rl.DarkGreen
    gameOver = true
    return true
}

func main() {
    rand.Seed(time.Now().UnixNano())
    rand.Shuffle(15, func(i, j int) {
        cubes[i], cubes[j] = cubes[j], cubes[i]
    })
    rl.InitWindow(screenWidth, screenHeight, "15-puzzle game using 3D cubes")
    rl.SetTargetFPS(60)
    var x, y = float32(screenWidth) / 10, float32(radius)
    for i := 0; i < 4; i++ {
        cx := 2 * x * float32(i+1)
        for j := 0; j < 4; j++ {
            cy := (x + y) * float32(j+1)
            centers[j*4+i] = rl.NewVector2(cx, cy)
        }
    }

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.Black)
        for i := 0; i < 16; i++ {
            drawCube(cubes[i], i)
        }

        if !completed() {
            m := fmt.Sprintf("Moves = %d", moves)
            rl.DrawText(m, 4*int32(x), 13*int32(y), fontSize, rl.RayWhite)
        } else {
            m := fmt.Sprintf("You've completed the puzzle in %d moves!", moves)
            rl.DrawText(m, 3*int32(x), 13*int32(y), fontSize, rl.RayWhite)
        }
        rl.EndDrawing()
        updateGame()
    }

    rl.CloseWindow()
}
