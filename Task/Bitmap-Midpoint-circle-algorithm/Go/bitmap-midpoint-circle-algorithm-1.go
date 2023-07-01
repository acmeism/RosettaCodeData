package raster

// Circle plots a circle with center x, y and radius r.
// Limiting behavior:
// r < 0 plots no pixels.
// r = 0 plots a single pixel at x, y.
// r = 1 plots four pixels in a diamond shape around the center pixel at x, y.
func (b *Bitmap) Circle(x, y, r int, p Pixel) {
    if r < 0 {
        return
    }
    // Bresenham algorithm
    x1, y1, err := -r, 0, 2-2*r
    for {
        b.SetPx(x-x1, y+y1, p)
        b.SetPx(x-y1, y-x1, p)
        b.SetPx(x+x1, y-y1, p)
        b.SetPx(x+y1, y+x1, p)
        r = err
        if r > x1 {
            x1++
            err += x1*2 + 1
        }
        if r <= y1 {
            y1++
            err += y1*2 + 1
        }
        if x1 >= 0 {
            break
        }
    }
}

func (b *Bitmap) CircleRgb(x, y, r int, c Rgb) {
    b.Circle(x, y, r, c.Pixel())
}
