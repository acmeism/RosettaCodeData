package raster

const b3Seg = 30

func (b *Bitmap) Bézier3(x1, y1, x2, y2, x3, y3, x4, y4 int, p Pixel) {
    var px, py [b3Seg + 1]int
    fx1, fy1 := float64(x1), float64(y1)
    fx2, fy2 := float64(x2), float64(y2)
    fx3, fy3 := float64(x3), float64(y3)
    fx4, fy4 := float64(x4), float64(y4)
    for i := range px {
        d := float64(i) / b3Seg
        a := 1 - d
        b, c := a * a, d * d
        a, b, c, d = a*b, 3*b*d, 3*a*c, c*d
        px[i] = int(a*fx1 + b*fx2 + c*fx3 + d*fx4)
        py[i] = int(a*fy1 + b*fy2 + c*fy3 + d*fy4)
    }
    x0, y0 := px[0], py[0]
    for i := 1; i <= b3Seg; i++ {
        x1, y1 := px[i], py[i]
        b.Line(x0, y0, x1, y1, p)
        x0, y0 = x1, y1
    }
}

func (b *Bitmap) Bézier3Rgb(x1, y1, x2, y2, x3, y3, x4, y4 int, c Rgb) {
    b.Bézier3(x1, y1, x2, y2, x3, y3, x4, y4, c.Pixel())
}
