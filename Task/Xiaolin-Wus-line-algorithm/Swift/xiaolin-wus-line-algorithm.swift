import Darwin
// apply pixel of color at x,y with an OVER blend to the bitmap
public func pixel(color: Color, x: Int, y: Int) {
    let idx = x + y * self.width
    if idx >= 0 && idx < self.bitmap.count {
        self.bitmap[idx] = self.blendColors(bot: self.bitmap[idx], top: color)
    }
}

// return the fractional part of a Double
func fpart(_ x: Double) -> Double {
    return modf(x).1
}

// reciprocal of the fractional part of a Double
func rfpart(_ x: Double) -> Double {
    return 1 - fpart(x)
}

// draw a 1px wide line using Xiolin Wu's antialiased line algorithm
public func smoothLine(_ p0: Point, _ p1: Point) {
    var x0 = p0.x, x1 = p1.x, y0 = p0.y, y1 = p1.y //swapable ptrs
    let steep = abs(y1 - y0) > abs(x1 - x0)
    if steep {
        swap(&x0, &y0)
        swap(&x1, &y1)
    }
    if x0 > x1 {
        swap(&x0, &x1)
        swap(&y0, &y1)
    }
    let dX = x1 - x0
    let dY = y1 - y0

    var gradient: Double
    if dX == 0.0 {
        gradient = 1.0
    }
    else {
        gradient = dY / dX
    }

    // handle endpoint 1
    var xend = round(x0)
    var yend = y0 + gradient * (xend - x0)
    var xgap = self.rfpart(x0 + 0.5)
    let xpxl1 = Int(xend)
    let ypxl1 = Int(yend)

    // first y-intersection for the main loop
    var intery = yend + gradient

    if steep {
        self.pixel(color: self.strokeColor.colorWithAlpha(self.rfpart(yend) * xgap), x: ypxl1, y: xpxl1)
        self.pixel(color: self.strokeColor.colorWithAlpha(self.fpart(yend) * xgap), x: ypxl1 + 1, y: xpxl1)
    }
    else {
        self.pixel(color: self.strokeColor.colorWithAlpha(self.rfpart(yend) * xgap), x: xpxl1, y: ypxl1)
        self.pixel(color: self.strokeColor.colorWithAlpha(self.fpart(yend) * xgap), x: xpxl1, y: ypxl1 + 1)
    }

    xend = round(x1)
    yend = y1 + gradient * (xend - x1)
    xgap = self.fpart(x1 + 0.5)
    let xpxl2 = Int(xend)
    let ypxl2 = Int(yend)

    // handle second endpoint
    if steep {
        self.pixel(color: self.strokeColor.colorWithAlpha(self.rfpart(yend) * xgap), x: ypxl2, y: xpxl2)
        self.pixel(color: self.strokeColor.colorWithAlpha(self.fpart(yend) * xgap), x: ypxl2 + 1, y: xpxl2)
    }
    else {
        self.pixel(color: self.strokeColor.colorWithAlpha(self.rfpart(yend) * xgap), x: xpxl2, y: ypxl2)
        self.pixel(color: self.strokeColor.colorWithAlpha(self.fpart(yend) * xgap), x: xpxl2, y: ypxl2 + 1)
    }

    // main loop
    if steep {
        for x in xpxl1+1..<xpxl2 {
            self.pixel(color: self.strokeColor.colorWithAlpha(self.rfpart(intery)), x: Int(intery), y: x)
            self.pixel(color: self.strokeColor.colorWithAlpha(self.fpart(intery)), x: Int(intery) + 1, y:x)
            intery += gradient
        }
    }
    else {
        for x in xpxl1+1..<xpxl2 {
            self.pixel(color: self.strokeColor.colorWithAlpha(self.rfpart(intery)), x: x, y: Int(intery))
            self.pixel(color: self.strokeColor.colorWithAlpha(self.fpart(intery)), x: x, y: Int(intery) + 1)
            intery += gradient
        }
    }
}
