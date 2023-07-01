package main

import "github.com/fogleman/gg"

var points []gg.Point

const width = 81

func peano(x, y, lg, i1, i2 int) {
    if lg == 1 {
        px := float64(width-x) * 10
        py := float64(width-y) * 10
        points = append(points, gg.Point{px, py})
        return
    }
    lg /= 3
    peano(x+2*i1*lg, y+2*i1*lg, lg, i1, i2)
    peano(x+(i1-i2+1)*lg, y+(i1+i2)*lg, lg, i1, 1-i2)
    peano(x+lg, y+lg, lg, i1, 1-i2)
    peano(x+(i1+i2)*lg, y+(i1-i2+1)*lg, lg, 1-i1, 1-i2)
    peano(x+2*i2*lg, y+2*(1-i2)*lg, lg, i1, i2)
    peano(x+(1+i2-i1)*lg, y+(2-i1-i2)*lg, lg, i1, i2)
    peano(x+2*(1-i1)*lg, y+2*(1-i1)*lg, lg, i1, i2)
    peano(x+(2-i1-i2)*lg, y+(1+i2-i1)*lg, lg, 1-i1, i2)
    peano(x+2*(1-i2)*lg, y+2*i2*lg, lg, 1-i1, i2)
}

func main() {
    peano(0, 0, width, 0, 0)
    dc := gg.NewContext(820, 820)
    dc.SetRGB(1, 1, 1) // White background
    dc.Clear()
    for _, p := range points {
        dc.LineTo(p.X, p.Y)
    }
    dc.SetRGB(1, 0, 1) // Magenta curve
    dc.SetLineWidth(1)
    dc.Stroke()
    dc.SavePNG("peano.png")
}
