package main

import "github.com/fogleman/gg"

var points []gg.Point

const width = 64

func hilbert(x, y, lg, i1, i2 int) {
    if lg == 1 {
        px := float64(width-x) * 10
        py := float64(width-y) * 10
        points = append(points, gg.Point{px, py})
        return
    }
    lg >>= 1
    hilbert(x+i1*lg, y+i1*lg, lg, i1, 1-i2)
    hilbert(x+i2*lg, y+(1-i2)*lg, lg, i1, i2)
    hilbert(x+(1-i1)*lg, y+(1-i1)*lg, lg, i1, i2)
    hilbert(x+(1-i2)*lg, y+i2*lg, lg, 1-i1, i2)
}

func main() {
    hilbert(0, 0, width, 0, 0)
    dc := gg.NewContext(650, 650)
    dc.SetRGB(0, 0, 0) // Black background
    dc.Clear()
    for _, p := range points {
        dc.LineTo(p.X, p.Y)
    }
    dc.SetHexColor("#90EE90") // Light green curve
    dc.SetLineWidth(1)
    dc.Stroke()
    dc.SavePNG("hilbert.png")
}
