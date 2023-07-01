import gintro/[glib, gobject, gtk, gio, cairo]

const
  Width = 420
  Height = 420

const Colors = [[255.0, 255.0, 255.0], [0.0, 0.0, 0.0]]

#---------------------------------------------------------------------------------------------------

proc draw(area: DrawingArea; context: Context) =
  ## Draw the bars.

  const lineHeight = Height div 4

  var y = 0.0
  for lineWidth in [1.0, 2.0, 3.0, 4.0]:
    context.setLineWidth(lineWidth)
    var x = 0.0
    var colorIndex = 0
    while x < Width:
      context.setSource(Colors[colorIndex])
      context.moveTo(x, y)
      context.lineTo(x, y + lineHeight)
      context.stroke()
      colorIndex = 1 - colorIndex
      x += lineWidth
    y += lineHeight

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
  window.setTitle("Color pinstripe")

  # Create the drawing area.
  let area = newDrawingArea()
  window.add(area)

  # Connect the "draw" event to the callback to draw the bars.
  discard area.connect("draw", ondraw, pointer(nil))

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.Pinstripe")
discard app.connect("activate", activate)
discard app.run()
