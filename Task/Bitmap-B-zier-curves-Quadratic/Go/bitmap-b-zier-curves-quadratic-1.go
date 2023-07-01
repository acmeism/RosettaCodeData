package raster

const b2Seg = 20

func (b *Bitmap) Bézier2(x1, y1, x2, y2, x3, y3 int, p Pixel) {
    var px, py [b2Seg + 1]int
    fx1, fy1 := float64(x1), float64(y1)
    fx2, fy2 := float64(x2), float64(y2)
    fx3, fy3 := float64(x3), float64(y3)
    for i := range px {
        c := float64(i) / b2Seg
        a := 1 - c
        a, b, c := a*a, 2 * c * a, c*c
        px[i] = int(a*fx1 + b*fx2 + c*fx3)
        py[i] = int(a*fy1 + b*fy2 + c*fy3)
    }
    x0, y0 := px[0], py[0]
    for i := 1; i <= b2Seg; i++ {
        x1, y1 := px[i], py[i]
        b.Line(x0, y0, x1, y1, p)
        x0, y0 = x1, y1
    }
}

func (b *Bitmap) Bézier2Rgb(x1, y1, x2, y2, x3, y3 int, c Rgb) {
    b.Bézier2(x1, y1, x2, y2, x3, y3, c.Pixel())
}
