def floodFill(image, x, y, newColor) {
  def matchColor := image[x, y]
  def w := image.width()
  def h := image.height()

  /** For any given pixel x,y, this algorithm first fills a contiguous
      horizontal line segment of pixels containing that pixel, then
      recursively scans the two adjacent rows over the same horizontal
      interval. Let this be invocation 0, and the immediate recursive
      invocations be 1, 2, 3, ..., # be pixels of the wrong color, and
      * be where each scan starts; the fill ordering is as follows:

      --------------##########-------
      -...1111111111*11####*33333...-
      ###########000*000000000000...-
      -...2222222222*22222##*4444...-
      --------------------##---------

      Each invocation returns the x coordinate of the rightmost pixel it filled,
      or x0 if none were.

      Since it is recursive, this algorithm is unsuitable for large images
      with small stacks.
    */
  def fillScan(var x0, y) {
    if (y >= 0 && y < h && x0 >= 0 && x0 < w) {
      image[x0, y] := newColor
      var x1 := x0

      # Fill rightward
      while (x1 < w - 1 && image.test(x1 + 1, y, matchColor)) {
        x1 += 1
        image[x1, y] := newColor # This could be replaced with a horizontal-line drawing operation
      }

      # Fill leftward
      while (x0 > 0 && image.test(x0 - 1, y, matchColor)) {
        x0 -= 1
        image[x0, y] := newColor
      }

      if (x0 > x1) { return x0 } # Filled at most center

      # x0..x1 is now a run of newly-filled pixels.

      # println(`Filled $y $x0..$x1`)
      # println(image)

      # Scan the lines above and below
      for ynext in [y - 1, y + 1] {
        if (ynext >= 0 && ynext < h) {
          var x := x0
          while (x <= x1) {
            if (image.test(x, ynext, matchColor)) {
              x := fillScan(x, ynext)
            }
            x += 1
          }
        }
      }

      return x1
    } else {
      return x0
    }
  }

  fillScan(x, y)
}
