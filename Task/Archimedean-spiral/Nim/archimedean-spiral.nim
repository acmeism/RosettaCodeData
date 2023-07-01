import math

import gintro/[glib, gobject, gtk, gio, cairo]

const

  Width = 601
  Height = 601

  Limit = 12 * math.PI

  Origin = (x: float(Width div 2), y: float(Height div 2))
  B = floor((Width div 2) / Limit)

#---------------------------------------------------------------------------------------------------

proc draw(area: DrawingArea; context: Context) =
  ## Draw the spiral.

  var theta = 0.0
  var delta = 0.01
  var (prevx, prevy) = Origin

  # Clear the region.
  context.moveTo(0, 0)
  context.setSource(0.0, 0.0, 0.0)
  context.paint()

  # Draw the spiral.
  context.setSource(1.0, 1.0, 0.0)
  context.moveTo(Origin.x, Origin.y)
  while theta < Limit:
    let r = B * theta
    let x = Origin.x + r * cos(theta)   # X-coordinate on drawing area.
    let y = Origin.y + r * sin(theta)   # Y-coordinate on drawing area.
    context.lineTo(x, y)
    context.stroke()
    # Set data for next round.
    context.moveTo(x, y)
    prevx = x
    prevy = y
    theta += delta

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
  window.setTitle("Archimedean spiral")

  # Create the drawing area.
  let area = newDrawingArea()
  window.add(area)

  # Connect the "draw" event to the callback to draw the spiral.
  discard area.connect("draw", ondraw, pointer(nil))

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.spiral")
discard app.connect("activate", activate)
discard app.run()
