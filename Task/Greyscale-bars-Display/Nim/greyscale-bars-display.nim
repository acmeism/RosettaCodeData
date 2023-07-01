import gintro/[glib, gobject, gtk, gio, cairo]

const
  Width = 640
  Height = 480

#---------------------------------------------------------------------------------------------------

proc draw(area: DrawingArea; context: Context) =
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
      context.rectangle(x, y, rectWidth, rectHeight)
      context.setSource([grey, grey, grey])
      context.fill()
      x += rectWidth
      grey += incr

    y += rectHeight
    nrect *= 2

#---------------------------------------------------------------------------------------------------

proc onDraw(area: DrawingArea; context: Context; data: pointer): bool =
  ## Callback to draw/redraw the drawing area contents.

  area.draw(context)
  result = true

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setSizeRequest(Width, Height)
  window.setTitle("Greyscale bars")

  # Create the drawing area.
  let area = newDrawingArea()
  window.add(area)

  # Connect the "draw" event to the callback to draw the spiral.
  discard area.connect("draw", ondraw, pointer(nil))

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.GreyscaleBars")
discard app.connect("activate", activate)
discard app.run()
