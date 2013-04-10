package raster

// Line draws line by Bresenham's algorithm.
func (b *Bitmap) Line(x0, y0, x1, y1 int, p Pixel) {
    // implemented straight from WP pseudocode
    dx := x1 - x0
    if dx < 0 {
        dx = -dx
    }
    dy := y1 - y0
    if dy < 0 {
        dy = -dy
    }
    var sx, sy int
    if x0 < x1 {
        sx = 1
    } else {
        sx = -1
    }
    if y0 < y1 {
        sy = 1
    } else {
        sy = -1
    }
    err := dx - dy

    for {
        b.SetPx(x0, y0, p)
        if x0 == x1 && y0 == y1 {
            break
        }
        e2 := 2 * err
        if e2 > -dy {
            err -= dy
            x0 += sx
        }
        if e2 < dx {
            err += dx
            y0 += sy
        }
    }
}

func (b *Bitmap) LineRgb(x0, y0, x1, y1 int, c Rgb) {
    b.Line(x0, y0, x1, y1, c.Pixel())
}
