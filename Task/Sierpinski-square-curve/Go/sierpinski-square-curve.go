package main

import (
    "github.com/fogleman/gg"
    "github.com/trubitsyn/go-lindenmayer"
    "log"
    "math"
)

const twoPi = 2 * math.Pi

var (
    width  = 770.0
    height = 770.0
    dc     = gg.NewContext(int(width), int(height))
)

var cx, cy, h, theta float64

func main() {
    dc.SetRGB(0, 0, 1) // blue background
    dc.Clear()
    cx, cy = 10, height/2+5
    h = 6
    sys := lindenmayer.Lsystem{
        Variables: []rune{'X'},
        Constants: []rune{'F', '+', '-'},
        Axiom:     "F+XF+F+XF",
        Rules: []lindenmayer.Rule{
            {"X", "XF-F+F-XF+F+XF-F+F-X"},
        },
        Angle: math.Pi / 2, // 90 degrees in radians
    }
    result := lindenmayer.Iterate(&sys, 5)
    operations := map[rune]func(){
        'F': func() {
            newX, newY := cx+h*math.Sin(theta), cy-h*math.Cos(theta)
            dc.LineTo(newX, newY)
            cx, cy = newX, newY
        },
        '+': func() {
            theta = math.Mod(theta+sys.Angle, twoPi)
        },
        '-': func() {
            theta = math.Mod(theta-sys.Angle, twoPi)
        },
    }
    if err := lindenmayer.Process(result, operations); err != nil {
        log.Fatal(err)
    }
    // needed to close the square at the extreme left
    operations['+']()
    operations['F']()

    // create the image and save it
    dc.SetRGB255(255, 255, 0) // yellow curve
    dc.SetLineWidth(2)
    dc.Stroke()
    dc.SavePNG("sierpinski_square_curve.png")
}
