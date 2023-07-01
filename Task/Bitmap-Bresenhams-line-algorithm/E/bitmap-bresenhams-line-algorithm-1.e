def swap(&left, &right) { # From [[Generic swap]]
  def t := left
  left := right
  right := t
}

def drawLine(image, var x0, var y0, var x1, var y1, color) {
    def steep := (y1 - y0).abs() > (x1 - x0).abs()
    if (steep) {
        swap(&x0, &y0)
        swap(&x1, &y1)
    }
    if (x0 > x1) {
        swap(&x0, &x1)
        swap(&y0, &y1)
    }
    def deltax := x1 - x0
    def deltay := (y1 - y0).abs()
    def ystep := if (y0 < y1) { 1 } else { -1 }
    var error := deltax // 2
    var y := y0
    for x in x0..x1 {
        if (steep) { image[y, x] := color } else { image[x, y] := color }
        error -= deltay
        if (error < 0) {
            y += ystep
            error += deltax
        }
    }
}
