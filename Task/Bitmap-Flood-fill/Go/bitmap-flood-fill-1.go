package raster

func (b *Bitmap) Flood(x, y int, repl Pixel) {
    targ, _ := b.GetPx(x, y)
    var ff func(x, y int)
    ff = func(x, y int) {
        p, ok := b.GetPx(x, y)
        if ok && p.R == targ.R && p.G == targ.G && p.B == targ.B {
            b.SetPx(x, y, repl)
            ff(x-1, y)
            ff(x+1, y)
            ff(x, y-1)
            ff(x, y+1)
        }
    }
    ff(x, y)
}
