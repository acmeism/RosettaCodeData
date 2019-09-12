package main

import (
    rl "github.com/gen2brain/raylib-go/raylib"
    "math"
    "strings"
)

type hexagon struct {
    x, y     float32
    letter   rune
    selected bool
}

func (h hexagon) points(r float32) []rl.Vector2 {
    res := make([]rl.Vector2, 7)
    for i := 0; i < 7; i++ {
        fi := float64(i)
        res[i].X = h.x + r*float32(math.Cos(math.Pi*fi/3))
        res[i].Y = h.y + r*float32(math.Sin(math.Pi*fi/3))
    }
    return res
}

func inHexagon(pts []rl.Vector2, pt rl.Vector2) bool {
    rec := rl.NewRectangle(pts[4].X, pts[4].Y, pts[5].X-pts[4].X, pts[2].Y-pts[4].Y)
    if rl.CheckCollisionPointRec(pt, rec) {
        return true
    }
    if rl.CheckCollisionPointTriangle(pt, pts[2], pts[3], pts[4]) {
        return true
    }
    if rl.CheckCollisionPointTriangle(pt, pts[0], pts[1], pts[5]) {
        return true
    }
    return false
}

func main() {
    screenWidth := int32(600)
    screenHeight := int32(600)
    rl.InitWindow(screenWidth, screenHeight, "Honeycombs")
    rl.SetTargetFPS(60)

    letters := "LRDGITPFBVOKANUYCESM"
    runes := []rune(letters)
    var combs [20]hexagon
    var pts [20][]rl.Vector2

    x1, y1 := 150, 100
    x2, y2 := 225, 143
    w, h := 150, 87
    r := float32(w / 3)
    for i := 0; i < 20; i++ {
        var x, y int
        if i < 12 {
            x = x1 + (i%3)*w
            y = y1 + (i/3)*h
        } else {
            x = x2 + (i%2)*w
            y = y2 + (i-12)/2*h
        }
        combs[i] = hexagon{float32(x), float32(y), runes[i], false}
        pts[i] = combs[i].points(r)
    }

    nChosen := 0
    sChosen := "Chosen: "
    lChosen := "Last chosen: "

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.RayWhite)
        for i, c := range combs {
            ctr := pts[i][0]
            ctr.X -= r
            index := -1
            if key := rl.GetKeyPressed(); key != -1 {
                if key >= 97 && key <= 122 {
                    key -= 32
                }
                index = strings.IndexRune(letters, key)
            } else if rl.IsMouseButtonPressed(rl.MouseLeftButton) {
                pt := rl.Vector2{float32(rl.GetMouseX()), float32(rl.GetMouseY())}
                for i := 0; i < 20; i++ {
                    if inHexagon(pts[i], pt) {
                        index = i
                        break
                    }
                }
            }
            if index >= 0 {
                if !combs[index].selected {
                    combs[index].selected = true
                    nChosen++
                    s := string(combs[index].letter)
                    sChosen += s
                    lChosen = "Last chosen: " + s
                    if nChosen == 20 {
                        lChosen += " (All 20 Chosen!)"
                    }
                }
            }
            if !c.selected {
                rl.DrawPoly(ctr, 6, r-1, 30, rl.Yellow)
            } else {
                rl.DrawPoly(ctr, 6, r-1, 30, rl.Magenta)
            }
            rl.DrawText(string(c.letter), int32(c.x)-5, int32(c.y)-10, 32, rl.Black)
            rl.DrawPolyExLines(pts[i], 7, rl.Black)
            rl.DrawText(sChosen, 100, 525, 24, rl.Black)
            rl.DrawText(lChosen, 100, 565, 24, rl.Black)
        }
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
