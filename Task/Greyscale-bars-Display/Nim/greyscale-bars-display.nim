import gtk2, gdk2, cairo

const
  Width = 640
  Height = 480


proc draw(area: PDrawingArea; cr: ptr Context) =
  ## Draw the greyscale bars.

  const
    Black = 0.0
    White = 1.0

  var y = 0.0
  var nrect = 8
  let rectHeight = Height / 4

  # Draw quarters.
  for quarter in 0..3:
    let rectWidth = Width / nrect
    var x = 0.0
    var (grey, incr) = if (quarter and 1) == 0: (Black, 1 / nrect) else: (White, -1 / nrect)

    # Draw rectangles.
    for _ in 1..nrect:
      cr.rectangle(x, y, rectWidth, rectHeight)
      cr.setSourceRgb(grey, grey, grey)
      cr.fill()
      x += rectWidth
      grey += incr

    y += rectHeight
    nrect *= 2


proc onExposeEvent(area: PDrawingArea; event: PEventExpose; data: pointer): bool =
  ## Callback to draw/redraw the drawing area contents.
  let cr = cairoCreate(area.window)
  area.draw(cr)
  result = true


proc onDestroyEvent(widget: PWidget; data: pointer): bool =
  mainQuit()


nimInit()
let window = windowNew(WINDOW_TOPLEVEL)
window.setSizeRequest(Width, Height)
window.setTitle("Greyscale bars")
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

# Create the drawing area.
let area = drawingAreaNew()
window.add area

# Connect the "expose" event to the callback to draw the bars.
discard area.signalConnect("expose-event", SIGNAL_FUNC(onExposeEvent), nil)

window.showAll()
main()
