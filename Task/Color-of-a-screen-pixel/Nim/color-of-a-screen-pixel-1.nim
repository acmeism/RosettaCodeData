import gtk2, gdk2, gdk2pixbuf

type Color = tuple[r, g, b: byte]

gtk2.nim_init()

proc getPixelColor(x, y: int32): Color =
  var p = pixbufNew(COLORSPACE_RGB, false, 8, 1, 1)
  discard p.getFromDrawable(getDefaultRootWindow().Drawable,
    getDefaultScreen().getSystemColormap(), x, y, 0, 0, 1, 1)
  result = cast[ptr Color](p.getPixels)[]

echo getPixelColor(0, 0)
