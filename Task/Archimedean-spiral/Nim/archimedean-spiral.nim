import std/math
import cairo

const

  Width = 400
  Height = 400

  Limit = 12 * math.PI

  Origin = (x: float(Width div 2), y: float(Height div 2))
  B = floor((Width div 2) / Limit)


proc drawSpiral(surface: ptr Surface) =
  ## Draw the spiral.

  let context = create(surface)

  var theta = 0.0
  var delta = 0.01
  var (prevx, prevy) = Origin

  # Clear the region.
  context.moveTo(0, 0)
  context.setSourceRgb(0.0, 0.0, 0.0)
  context.paint()

  # Draw the spiral.
  context.setSourceRgb(1.0, 1.0, 0.0)
  context.moveTo(Origin.x, Origin.y)
  while theta < Limit:
    let r = B * theta
    let x = Origin.x + r * cos(theta)
    let y = Origin.y + r * sin(theta)
    context.lineTo(x, y)
    context.stroke()
    # Set data for next round.
    context.moveTo(x, y)
    prevx = x
    prevy = y
    theta += delta

  context.destroy()


let surface = imageSurfaceCreate(FormatRgb24, Width, Height)
surface.drawSpiral()
if surface.writeToPng("archimedean_spiral.png") != StatusSuccess:
  quit "Error while saving file.", QuitFailure
surface.destroy()
