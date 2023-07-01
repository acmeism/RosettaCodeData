import gintro/[glib, gobject, gtk, gio, cairo]

const
  Width = 400
  Height = 300

#---------------------------------------------------------------------------------------------------

proc draw(area: DrawingArea; context: Context) =
  ## Draw the color bars.

  const Colors = [[0.0, 0.0, 0.0], [255.0, 0.0, 0.0],
                  [0.0, 255.0, 0.0], [0.0, 0.0, 255.0],
                  [255.0, 0.0, 255.0], [0.0, 255.0, 255.0],
                  [255.0, 255.0, 0.0], [255.0, 255.0, 255.0]]

  const
    RectWidth = float(Width div Colors.len)
    RectHeight = float(Height)

  var x = 0.0
  for color in Colors:
    context.rectangle(x, 0, RectWidth, RectHeight)
    context.setSource(color)
    context.fill()
    x += RectWidth

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
  window.setTitle("Color bars")

  # Create the drawing area.
  let area = newDrawingArea()
  window.add(area)

  # Connect the "draw" event to the callback to draw the spiral.
  discard area.connect("draw", ondraw, pointer(nil))

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.ColorBars")
discard app.connect("activate", activate)
discard app.run()
