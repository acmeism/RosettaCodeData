import gtk2, gdk2, gdk2pixbuf
gtk2.nim_init()

proc getPixelColor(x, y: int32): auto =
  var p = pixbufNew(COLORSPACE_RGB, false, 8, 1, 1)
  discard p.getFromDrawable(getDefaultRootWindow().Drawable,
    getDefaultScreen().getSystemColormap(), x, y, 0, 0, 1, 1)
  result = cast[tuple[r, g, b: uint8]](p.getPixels[])

echo getPixelColor(0, 0)
