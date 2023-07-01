import gintro/[gtk, gobject, gio, gdk, gdkpixbuf]

type Color = tuple[r, g, b: byte]

proc getPixelColor(x, y: int32): Color =
  var pixbuf = pixbufGetFromWindow(getDefaultRootWindow(), x, y, 1, 1)
  result = cast[ptr Color](pixbuf.readPixels())[]

proc activate(app: Application) =
  ## Needed by GTK3.
  discard

let app = newApplication("org.gtk.example")
connect(app, "activate", activate)
discard run(app)

echo getPixelColor(1500, 800)
