package main

import (
    "github.com/fogleman/gg"
    "strings"
)

func wordFractal(i int) string {
    if i < 2 {
        if i == 1 {
            return "1"
        }
        return ""
    }
    var f1 strings.Builder
    f1.WriteString("1")
    var f2 strings.Builder
    f2.WriteString("0")
    for j := i - 2; j >= 1; j-- {
        tmp := f2.String()
        f2.WriteString(f1.String())
        f1.Reset()
        f1.WriteString(tmp)
    }
    return f2.String()
}

func draw(dc *gg.Context, x, y, dx, dy float64, wf string) {
    for i, c := range wf {
        dc.DrawLine(x, y, x+dx, y+dy)
        x += dx
        y += dy
        if c == '0' {
            tx := dx
            dx = dy
            if i%2 == 0 {
                dx = -dy
            }
            dy = -tx
            if i%2 == 0 {
                dy = tx
            }
        }
    }
}

func main() {
    dc := gg.NewContext(450, 620)
    dc.SetRGB(0, 0, 0)
    dc.Clear()
    wf := wordFractal(23)
    draw(dc, 20, 20, 1, 0, wf)
    dc.SetRGB(0, 1, 0)
    dc.SetLineWidth(1)
    dc.Stroke()
    dc.SavePNG("fib_wordfractal.png")
}
